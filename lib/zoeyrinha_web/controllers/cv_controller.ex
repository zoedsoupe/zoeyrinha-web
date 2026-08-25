defmodule ZoeyrinhaWeb.CVController do
  use ZoeyrinhaWeb, :controller

  def show(conn, _params) do
    render(conn, :show,
      html: Zoeyrinha.CV.html(conn.assigns.locale),
      page_title: "cv"
    )
  end
end
