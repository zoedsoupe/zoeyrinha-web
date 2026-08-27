defmodule ZoeyrinhaWeb.LandingController do
  use ZoeyrinhaWeb, :controller

  alias Zoeyrinha.{Blog, Talks}

  def show(conn, _params) do
    recent = conn.assigns.locale |> Blog.all_posts() |> Enum.take(3)
    talks = Talks.all_talks() |> Enum.take(3)
    render(conn, :show, recent_posts: recent, recent_talks: talks)
  end
end
