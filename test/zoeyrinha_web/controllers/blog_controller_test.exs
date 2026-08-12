defmodule ZoeyrinhaWeb.BlogControllerTest do
  use ZoeyrinhaWeb.ConnCase, async: false

  test "GET /posts/:id renders 200 with the fallback when the thread fetch fails",
       %{conn: conn} do
    # hello-world has a bsky_thread and the FakeClient default for
    # get_thread/1 is {:error, :not_stubbed}, so the page degrades to the
    # fallback link instead of crashing
    conn = get(conn, ~p"/posts/hello-world")

    assert body = html_response(conn, 200)
    assert body =~ "Comments are unavailable right now."
  end
end
