defmodule ZoeyrinhaWeb.LandingController do
  use ZoeyrinhaWeb, :controller

  alias Zoeyrinha.Blog

  def show(conn, _params) do
    recent = conn.assigns.locale |> Blog.all_posts() |> Enum.take(3)
    render(conn, :show, recent_posts: recent)
  end
end
