defmodule ZoeyrinhaWeb.SitemapController do
  use ZoeyrinhaWeb, :controller

  alias Zoeyrinha.Blog

  @static_paths ["/", "/posts"]

  def index(conn, _params) do
    conn
    |> put_resp_content_type("text/xml")
    |> send_resp(200, sitemap())
  end

  defp sitemap do
    url = ZoeyrinhaWeb.Endpoint.url()
    paths = @static_paths ++ Enum.map(Blog.all_posts(), &"/posts/#{&1.id}")
    urls = Enum.map_join(paths, "\n", fn path -> "  <url><loc>#{url}#{path}</loc></url>" end)

    """
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    #{urls}
    </urlset>
    """
  end
end
