defmodule ZoeyrinhaWeb.Router do
  use ZoeyrinhaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ZoeyrinhaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ZoeyrinhaWeb do
    pipe_through [:browser]

    get "/", LandingController, :show
    get "/me", MeController, :show
    get "/card", CardController, :show
  end
end
