defmodule ZoeyrinhaWeb.BlogHTMLTest do
  use ZoeyrinhaWeb.ConnCase, async: true

  import Phoenix.Template

  alias Zoeyrinha.Blog.Post

  defp post(attrs \\ []) do
    struct!(
      %Post{
        id: "hello-world",
        title: "hello, world",
        body: "<p>hi</p>",
        description: "desc",
        tags: ["meta"],
        date: ~D[2026-07-14],
        bsky_thread: "at://did:plc:zoey/app.bsky.feed.post/abc123"
      },
      attrs
    )
  end

  defp render_show(conn, assigns) do
    # live_render needs the endpoint in conn.private, which the controller
    # pipeline normally provides
    conn = Plug.Conn.put_private(conn, :phoenix_endpoint, ZoeyrinhaWeb.Endpoint)

    render_to_string(
      ZoeyrinhaWeb.BlogHTML,
      "show",
      "html",
      [conn: conn, post: post(), locale: "en", series: nil, thread_url: nil] ++ assigns
    )
  end

  test "shows the language badge when the post language differs from the locale", %{conn: conn} do
    html = render_show(conn, post: post(lang: "pt_BR"))

    assert html =~ "this post is only available in português"
  end

  test "hides the language badge when the post language matches the locale", %{conn: conn} do
    html = render_show(conn, [])

    refute html =~ "only available"
  end

  test "embeds the comments LiveView behind a loading skeleton when the post has a thread",
       %{conn: conn} do
    thread_url = "https://bsky.app/profile/did:plc:zoey/post/abc123"
    html = render_show(conn, thread_url: thread_url)

    assert html =~ "reply on Bluesky"
    assert html =~ thread_url
    assert html =~ ~s(data-phx-session)
    assert html =~ "animate-pulse"
  end

  test "renders nothing when the post has no bsky thread", %{conn: conn} do
    html = render_show(conn, post: post(bsky_thread: nil))

    refute html =~ "reply on Bluesky"
    refute html =~ "comments"
  end
end
