defmodule ZoeyrinhaWeb.LandingController do
  use ZoeyrinhaWeb, :controller

  def show(conn, _params) do
    render(conn, :show)
  end
end
