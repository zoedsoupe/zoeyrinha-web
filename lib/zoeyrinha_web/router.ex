defmodule ZoeyrinhaWeb.Router do
  use ZoeyrinhaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ZoeyrinhaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ZoeyrinhaWeb.Plugs.SetLocale
  end

  pipeline :rss do
    plug :accepts, ["xml"]
    plug :put_root_layout, false
  end

  scope "/", ZoeyrinhaWeb do
    pipe_through [:browser]

    get "/", LandingController, :show

    get "/posts", BlogController, :index
    get "/posts/:id", BlogController, :show
  end

  scope "/", ZoeyrinhaWeb do
    pipe_through [:rss]

    get "/rss.xml", RssController, :index
    get "/sitemap.xml", SitemapController, :index
  end
end
