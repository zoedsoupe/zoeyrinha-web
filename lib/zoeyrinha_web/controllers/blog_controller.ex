defmodule ZoeyrinhaWeb.BlogController do
  use ZoeyrinhaWeb, :controller

  alias Zoeyrinha.Blog
  alias Zoeyrinha.Blog.Comments
  alias Zoeyrinha.Blog.Comments.Cache

  def index(conn, _params) do
    render(conn, :index, posts: Blog.all_posts(conn.assigns.locale), page_title: "blog")
  end

  def show(conn, %{"id" => id}) do
    post = Blog.get_post_by_id!(id, conn.assigns.locale)
    {comments, thread_url} = load_comments(post)

    render(conn, :show,
      post: post,
      comments: comments,
      thread_url: thread_url,
      locale: conn.assigns.locale,
      page_title: post.title
    )
  end

  defp load_comments(%{bsky_thread: nil}), do: {:none, nil}

  defp load_comments(%{bsky_thread: at_uri}) do
    case Cache.fetch(at_uri) do
      {:ok, comments} -> {comments, Comments.post_url(at_uri)}
      {:error, _} -> {:error, Comments.post_url(at_uri)}
    end
  end
end
