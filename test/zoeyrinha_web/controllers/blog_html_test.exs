defmodule ZoeyrinhaWeb.BlogHTMLTest do
  use ZoeyrinhaWeb.ConnCase, async: true

  import Phoenix.Template

  alias Zoeyrinha.Blog.Comment
  alias Zoeyrinha.Blog.Post

  defp post do
    %Post{
      id: "hello-world",
      title: "hello, world",
      body: "<p>hi</p>",
      description: "desc",
      tags: ["meta"],
      date: ~D[2026-07-14],
      bsky_thread: "at://did:plc:zoey/app.bsky.feed.post/abc123"
    }
  end

  defp render_show(assigns) do
    render_to_string(
      ZoeyrinhaWeb.BlogHTML,
      "show",
      "html",
      [post: post(), locale: "en", series: nil] ++ assigns
    )
  end

  test "shows the language badge when the post language differs from the locale" do
    pt_post = %{post() | lang: "pt_BR"}

    html =
      render_to_string(ZoeyrinhaWeb.BlogHTML, "show", "html",
        post: pt_post,
        locale: "en",
        series: nil,
        comments: :none,
        thread_url: nil
      )

    assert html =~ "this post is only available in português"
  end

  test "hides the language badge when the post language matches the locale" do
    html = render_show(comments: :none, thread_url: nil)

    refute html =~ "only available"
  end

  test "renders the comments section with a nested comment tree" do
    comment = %Comment{
      uri: "at://did:plc:bob/app.bsky.feed.post/rep1",
      url: "https://bsky.app/profile/did:plc:bob/post/rep1",
      author_handle: "bob.bsky.social",
      author_display_name: "Bob",
      author_did: "did:plc:bob",
      text: "great post",
      segments: [
        {:text, "great post "},
        {:link, "https://example.com", "https://example.com"}
      ],
      created_at: ~U[2026-08-01 11:00:00Z],
      like_count: 3,
      reply_count: 1,
      replies: [
        %Comment{
          author_handle: "carol.bsky.social",
          author_did: "did:plc:carol",
          text: "thanks",
          segments: [{:text, "thanks"}]
        }
      ]
    }

    html =
      render_show(
        comments: [comment],
        thread_url: "https://bsky.app/profile/did:plc:zoey/post/abc123"
      )

    assert html =~ "reply on Bluesky"
    assert html =~ "https://bsky.app/profile/did:plc:zoey/post/abc123"
    assert html =~ "Bob"
    assert html =~ "@bob.bsky.social"
    assert html =~ "great post"
    assert html =~ ~s(href="https://example.com")
    assert html =~ "3 likes"
    assert html =~ "1 replies"
    assert html =~ "thanks"
  end

  test "renders the fallback link when comments fail to load" do
    html =
      render_show(
        comments: :error,
        thread_url: "https://bsky.app/profile/did:plc:zoey/post/abc123"
      )

    assert html =~ "Comments are unavailable right now."
    assert html =~ "Read the thread on Bluesky."
    assert html =~ "https://bsky.app/profile/did:plc:zoey/post/abc123"
  end

  test "renders nothing when the post has no bsky thread" do
    html = render_show(comments: :none, thread_url: nil)

    refute html =~ "reply on Bluesky"
    refute html =~ "comments"
  end
end
