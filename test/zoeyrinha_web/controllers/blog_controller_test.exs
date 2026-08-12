defmodule ZoeyrinhaWeb.BlogControllerTest do
  use ZoeyrinhaWeb.ConnCase, async: false

  test "GET /posts/:id renders 200 without a comments section when the post has no bsky_thread",
       %{conn: conn} do
    conn = get(conn, ~p"/posts/hello-world")

    assert body = html_response(conn, 200)
    refute body =~ "reply on Bluesky"
  end
end
