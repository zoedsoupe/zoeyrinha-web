defmodule ZoeyrinhaWeb.CommentsLiveTest do
  use ZoeyrinhaWeb.ConnCase, async: false

  import Phoenix.LiveViewTest

  alias Zoeyrinha.Blog.Comments.Cache
  alias Zoeyrinha.Bsky.FakeClient

  @at_uri "at://did:plc:zoey/app.bsky.feed.post/abc123"
  @session %{"at_uri" => @at_uri, "locale" => "en"}

  setup do
    FakeClient.reset()
    Cache.clear()
    :ok
  end

  test "shows a loading skeleton before the thread resolves", %{conn: conn} do
    FakeClient.stub({:get_thread, @at_uri}, fn -> {:ok, thread([])} end)

    {:ok, _view, html} = live_isolated(conn, ZoeyrinhaWeb.CommentsLive, session: @session)

    assert html =~ "animate-pulse"
  end

  test "renders the nested comment tree once the async load completes", %{conn: conn} do
    FakeClient.stub({:get_thread, @at_uri}, fn ->
      {:ok,
       thread([
         %{
           post: %{
             uri: "at://did:plc:bob/app.bsky.feed.post/rep1",
             like_count: 3,
             reply_count: 1,
             record: %{
               text: "great post https://example.com",
               created_at: "2026-08-01T11:00:00Z",
               facets: [
                 %{
                   index: %{byte_start: 11, byte_end: 30},
                   features: [
                     %{"$type": "app.bsky.richtext.facet#link", uri: "https://example.com"}
                   ]
                 }
               ]
             },
             author: %{
               handle: "bob.bsky.social",
               display_name: "Bob",
               did: "did:plc:bob"
             }
           },
           replies: [
             %{
               post: %{
                 uri: "at://did:plc:carol/app.bsky.feed.post/rep2",
                 record: %{text: "thanks", created_at: "2026-08-01T12:00:00Z"},
                 author: %{handle: "carol.bsky.social", did: "did:plc:carol"}
               },
               replies: []
             }
           ]
         }
       ])}
    end)

    {:ok, view, _html} = live_isolated(conn, ZoeyrinhaWeb.CommentsLive, session: @session)
    html = render_async(view)

    assert html =~ "Bob"
    assert html =~ "@bob.bsky.social"
    assert html =~ "great post"
    assert html =~ ~s(href="https://example.com")
    assert html =~ "3 likes"
    assert html =~ "1 replies"
    assert html =~ "thanks"
  end

  test "a failed load offers retry, and retry recovers", %{conn: conn} do
    FakeClient.stub({:get_thread, @at_uri}, fn -> {:error, :boom} end)

    {:ok, view, _html} = live_isolated(conn, ZoeyrinhaWeb.CommentsLive, session: @session)
    html = render_async(view)

    assert html =~ "Comments are unavailable right now."
    assert html =~ "retry"

    Cache.clear()
    FakeClient.stub({:get_thread, @at_uri}, fn -> {:ok, thread([])} end)

    html =
      view |> element("button", "retry") |> render_click() |> then(fn _ -> render_async(view) end)

    assert html =~ "No comments yet."
  end

  defp thread(replies), do: %{thread: %{replies: replies}}
end
