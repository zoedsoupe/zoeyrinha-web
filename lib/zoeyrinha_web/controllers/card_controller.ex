defmodule ZoeyrinhaWeb.CardController do
  use ZoeyrinhaWeb, :controller

  def show(conn, _params) do
    render(conn, :show)
  end
end
