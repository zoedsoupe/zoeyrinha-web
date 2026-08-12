defmodule Zoeyrinha.Blog.Comments do
  @moduledoc """
  Pure functions over getPostThread responses: parsing the thread into a
  `Zoeyrinha.Blog.Comment` tree, splitting comment text into renderable
  segments from record facets, and mapping AT-URIs to bsky.app URLs.

  Input maps use the snaked atom keys produced by proto_rune's XRPC client.
  """

  alias Zoeyrinha.Blog.Comment

  @doc "Parses a getPostThread response (snaked atom keys) into a tree of top-level comments. Skips blocked/notFound nodes."
  @spec parse_thread(map()) :: {:ok, [Comment.t()]} | {:error, :invalid_thread}
  def parse_thread(%{thread: %{replies: replies}}) when is_list(replies) do
    {:ok, Enum.flat_map(replies, &parse_node/1)}
  end

  def parse_thread(_), do: {:error, :invalid_thread}

  # A node is a comment when it has a :post map; blockedPost/notFoundPost
  # nodes carry no :post and are skipped for free.
  defp parse_node(%{post: %{} = post, replies: replies}) when is_list(replies) do
    [to_comment(post, Enum.flat_map(replies, &parse_node/1))]
  end

  defp parse_node(%{post: %{} = post}), do: [to_comment(post, [])]
  defp parse_node(_), do: []

  defp to_comment(post, replies) do
    record = Map.get(post, :record, %{})
    author = Map.get(post, :author, %{})
    text = Map.get(record, :text, "") || ""
    facets = Map.get(record, :facets, []) || []

    %Comment{
      uri: Map.get(post, :uri),
      url: post_url(Map.get(post, :uri)),
      text: text,
      segments: segments(text, facets),
      created_at: parse_datetime(Map.get(record, :created_at)),
      author_handle: Map.get(author, :handle),
      author_display_name: Map.get(author, :display_name),
      author_avatar: Map.get(author, :avatar),
      author_did: Map.get(author, :did),
      like_count: Map.get(post, :like_count, 0) || 0,
      reply_count: Map.get(post, :reply_count, 0) || 0,
      replies: replies
    }
  end

  defp parse_datetime(nil), do: nil

  defp parse_datetime(iso) when is_binary(iso) do
    case DateTime.from_iso8601(iso) do
      {:ok, dt, _offset} -> dt
      {:error, _} -> nil
    end
  end

  @doc "Splits text into renderable segments from record facets (link and mention only; unknown facet types are left as plain text)."
  @spec segments(String.t(), [map()]) :: [Comment.segment()]
  def segments(text, facets) when is_binary(text) and is_list(facets) do
    size = byte_size(text)

    facets
    |> Enum.flat_map(&facet_span(&1, size))
    |> Enum.sort_by(fn {start, _end, _kind, _target} -> start end)
    |> Enum.reduce({0, []}, &append_span(&1, &2, text))
    |> then(fn {cursor, acc} ->
      if cursor < size,
        do: acc ++ [{:text, binary_part(text, cursor, size - cursor), nil}],
        else: acc
    end)
    |> Enum.reject(fn {_kind, text, _target} -> text == "" end)
    |> Enum.map(fn
      {:text, text, nil} -> {:text, text}
      segment -> segment
    end)
  end

  # overlapping spans (start before the cursor) are dropped
  defp append_span({s, _e, _kind, _target}, {cursor, acc}, _text) when s < cursor,
    do: {cursor, acc}

  defp append_span({s, e, kind, target}, {cursor, acc}, text) do
    gap = if s > cursor, do: [{:text, binary_part(text, cursor, s - cursor), nil}], else: []
    {e, acc ++ gap ++ [{kind, binary_part(text, s, e - s), target}]}
  end

  # returns {byte_start, byte_end, :link | :mention, target} or []
  defp facet_span(%{index: %{byte_start: s, byte_end: e}, features: features}, size)
       when is_integer(s) and is_integer(e) and s >= 0 and s < e and e <= size and
              is_list(features) do
    case Enum.find_value(features, &feature/1) do
      nil -> []
      {kind, target} -> [{s, e, kind, target}]
    end
  end

  defp facet_span(_, _), do: []

  defp feature(%{"$type": "app.bsky.richtext.facet#link", uri: uri}) when is_binary(uri),
    do: {:link, uri}

  defp feature(%{"$type": "app.bsky.richtext.facet#mention", did: did}) when is_binary(did),
    do: {:mention, did}

  defp feature(_), do: nil

  @doc "Converts an at://did/app.bsky.feed.post/rkey URI into the bsky.app web URL. nil on malformed input."
  @spec post_url(String.t() | nil) :: String.t() | nil
  def post_url("at://" <> rest) do
    case String.split(rest, "/") do
      [did, "app.bsky.feed.post", rkey] -> "https://bsky.app/profile/#{did}/post/#{rkey}"
      _ -> nil
    end
  end

  def post_url(_), do: nil
end
