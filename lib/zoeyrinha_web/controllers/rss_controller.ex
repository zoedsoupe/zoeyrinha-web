defmodule ZoeyrinhaWeb.RssController do
  use ZoeyrinhaWeb, :controller

  alias Zoeyrinha.Blog

  def index(conn, _params) do
    conn
    |> put_resp_content_type("application/rss+xml")
    |> send_resp(200, feed(Blog.all_posts()))
  end

  defp feed(posts) do
    url = ZoeyrinhaWeb.Endpoint.url()
    items = Enum.map_join(posts, "\n", &item(&1, url))

    """
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/">
      <channel>
        <title>zoeyrinha</title>
        <link>#{url}</link>
        <description>Notes on Elixir, distributed systems, and functional programming.</description>
        <language>en</language>
        <atom:link href="#{url}/rss.xml" rel="self" type="application/rss+xml"/>
    #{items}
      </channel>
    </rss>
    """
  end

  defp item(post, url) do
    link = "#{url}/posts/#{post.id}"

    """
        <item>
          <title>#{escape(post.title)}</title>
          <link>#{link}</link>
          <guid isPermaLink="true">#{link}</guid>
          <pubDate>#{rfc822(post.date)}</pubDate>
          <description>#{escape(post.description)}</description>
          <content:encoded><![CDATA[#{post.body}]]></content:encoded>
        </item>
    """
  end

  defp rfc822(%Date{} = date) do
    date
    |> DateTime.new!(~T[00:00:00], "Etc/UTC")
    |> Calendar.strftime("%a, %d %b %Y %H:%M:%S +0000")
  end

  defp escape(string) do
    string
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
  end
end
