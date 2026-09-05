defmodule ZoeyrinhaWeb.BlogController do
  use ZoeyrinhaWeb, :controller

  alias Zoeyrinha.Blog
  alias Zoeyrinha.Blog.Comments

  def index(conn, _params) do
    posts = Blog.all_posts(conn.assigns.locale)

    series_first =
      Map.new(posts, fn post ->
        {post.id, post.series && hd(Blog.series_for(post, conn.assigns.locale).posts).id}
      end)

    render(conn, :index,
      posts: posts,
      series_first: series_first,
      locale: conn.assigns.locale,
      page_title: "blog"
    )
  end

  def show(conn, %{"id" => id}) do
    post = Blog.get_post_by_id!(id, conn.assigns.locale)

    render(conn, :show,
      post: post,
      series: Blog.series_for(post, conn.assigns.locale),
      thread_url: post.bsky_thread && Comments.post_url(post.bsky_thread),
      locale: conn.assigns.locale,
      page_title: post.title,
      og_type: "article",
      og_title: post.title,
      og_description: post.description,
      og_image: og_image(conn, post)
    )
  end

  defp og_image(_conn, %{image: nil}), do: nil
  defp og_image(conn, %{image: path}), do: unverified_url(conn, path)
end
