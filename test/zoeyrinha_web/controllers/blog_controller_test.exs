defmodule ZoeyrinhaWeb.BlogControllerTest do
  use ZoeyrinhaWeb.ConnCase, async: false

  test "GET /posts/:id renders 200 with the comments LiveView embedded", %{conn: conn} do
    # hello-world has a bsky_thread; the thread itself loads asynchronously
    # inside the embedded LiveView, so the page renders regardless of the
    # Bluesky API being reachable
    conn = get(conn, ~p"/posts/hello-world")

    assert body = html_response(conn, 200)
    assert body =~ "reply on Bluesky"
    assert body =~ ~s(data-phx-session)
  end
end
