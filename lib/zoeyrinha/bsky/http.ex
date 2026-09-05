defmodule Zoeyrinha.Bsky.HTTP do
  @moduledoc """
  Zoeyrinha.Bsky.Client over :httpc and OTP's built-in JSON.

  Replaces the proto_rune dependency: the blog needs exactly three XRPC
  calls - an unauthenticated getPostThread against the public AppView, and
  createSession + createRecord for `mix blog.announce`. getPostThread
  responses are decoded and their keys snaked/atomized so
  Zoeyrinha.Blog.Comments.parse_thread/1 keeps working unchanged.
  """

  @behaviour Zoeyrinha.Bsky.Client

  @appview "https://public.api.bsky.app/xrpc"
  @pds "https://bsky.social/xrpc"

  @impl true
  def login(identifier, password) do
    case post("#{@pds}/com.atproto.server.createSession", %{
           identifier: identifier,
           password: password
         }) do
      {:ok, %{"accessJwt" => jwt, "did" => did, "handle" => handle}} ->
        {:ok, %{access_jwt: jwt, did: did, handle: handle}}

      {:ok, other} ->
        {:error, {:unexpected_response, other}}

      {:error, _} = error ->
        error
    end
  end

  @impl true
  def create_post(session, title, description, url) do
    prefix = "New post: #{title}\n\n#{description}\n\n"
    text = prefix <> url

    record = %{
      "$type" => "app.bsky.feed.post",
      "text" => text,
      "createdAt" => DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.to_iso8601(),
      "facets" => [
        %{
          "index" => %{
            "byteStart" => byte_size(prefix),
            "byteEnd" => byte_size(prefix) + byte_size(url)
          },
          "features" => [
            %{"$type" => "app.bsky.richtext.facet#link", "uri" => url}
          ]
        }
      ]
    }

    case post(
           "#{@pds}/com.atproto.repo.createRecord",
           %{repo: session.did, collection: "app.bsky.feed.post", record: record},
           bearer: session.access_jwt
         ) do
      {:ok, %{"uri" => at_uri}} -> {:ok, at_uri}
      {:ok, other} -> {:error, {:unexpected_response, other}}
      {:error, _} = error -> error
    end
  end

  @impl true
  def get_thread(at_uri) do
    query = URI.encode_query(%{uri: at_uri, depth: 6, parentHeight: 0})

    case get("#{@appview}/app.bsky.feed.getPostThread?#{query}") do
      {:ok, decoded} -> {:ok, snake_keys(decoded)}
      {:error, _} = error -> error
    end
  end

  # Comments.parse_thread/1 pattern-matches on snaked atom keys (the shape
  # proto_rune used to produce). Unknown keys keep their string form; the
  # parser never reads them.
  defp snake_keys(map) when is_map(map) do
    Map.new(map, fn {key, value} -> {snake_key(key), snake_keys(value)} end)
  end

  defp snake_keys(list) when is_list(list), do: Enum.map(list, &snake_keys/1)
  defp snake_keys(other), do: other

  defp snake_key("$type"), do: :"$type"

  defp snake_key(key) when is_binary(key) do
    key |> Macro.underscore() |> String.to_existing_atom()
  rescue
    ArgumentError -> key
  end

  defp get(url), do: request(:get, {String.to_charlist(url), []})

  defp post(url, payload, opts \\ []) do
    headers = [{~c"content-type", ~c"application/json"} | auth_headers(opts)]

    request(
      :post,
      {String.to_charlist(url), headers, ~c"application/json", JSON.encode!(payload)}
    )
  end

  defp auth_headers(opts) do
    case Keyword.get(opts, :bearer) do
      nil -> []
      token -> [{~c"authorization", ~c"Bearer #{token}"}]
    end
  end

  defp request(method, req) do
    case :httpc.request(method, req, [timeout: 10_000], body_format: :binary) do
      {:ok, {{_, status, _}, _headers, body}} when status in 200..299 ->
        JSON.decode(body)

      {:ok, {{_, status, _}, _headers, body}} ->
        {:error, {:http_error, status, body}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
