defmodule ZoeyrinhaWeb.TalkController do
  use ZoeyrinhaWeb, :controller

  alias Zoeyrinha.Talks

  def show(conn, _params) do
    render(conn, :index,
      talks: Talks.all_talks(),
      page_title: "talks",
      og_description: "Talks, workshops and podcast appearances."
    )
  end
end
