defmodule ZoeyrinhaWeb.BlogController do
  use ZoeyrinhaWeb, :controller

  alias Zoeyrinha.Blog

  def index(conn, _params) do
    render(conn, :index, posts: Blog.all_posts(), page_title: "blog")
  end

  def show(conn, %{"id" => id}) do
    post = Blog.get_post_by_id!(id)
    render(conn, :show, post: post, page_title: post.title)
  end
end
