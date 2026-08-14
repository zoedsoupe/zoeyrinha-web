defmodule Zoeyrinha.Bsky.ProtoRune do
  @moduledoc "Zoeyrinha.Bsky.Client implementation over proto_rune."
  @behaviour Zoeyrinha.Bsky.Client

  alias ProtoRune.RichText
  alias ProtoRune.XRPC.Client
  alias ProtoRune.XRPC.Query

  @appview_url "https://public.api.bsky.app/xrpc"

  @impl true
  def login(identifier, password) do
    ProtoRune.login(identifier, password)
  end

  @impl true
  def create_post(session, title, description, url) do
    rich_text =
      RichText.new()
      |> RichText.text("New post: #{title}\n\n#{description}\n\n")
      |> RichText.link(url, url)

    with {:ok, post_data} <- RichText.build(rich_text),
         {:ok, %{uri: at_uri}} <- ProtoRune.Bsky.post(session, post_data) do
      {:ok, at_uri}
    else
      {:ok, other} -> {:error, {:unexpected_response, other}}
      {:error, _} = error -> error
    end
  end

  @impl true
  def get_thread(at_uri) do
    # Hand-built query instead of Feed.get_post_thread/1 so the unauthenticated
    # read targets the public AppView; the generated function has no per-call
    # base_url knob.
    "app.bsky.feed.getPostThread"
    |> Query.new(base_url: @appview_url)
    |> Query.put_param(:uri, at_uri)
    |> Query.put_param(:depth, 6)
    |> Query.put_param(:parent_height, 0)
    |> Client.execute()
  end
end
