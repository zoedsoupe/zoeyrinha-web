defmodule ZoeyrinhaWeb.TalkControllerTest do
  use ZoeyrinhaWeb.ConnCase, async: true

  test "GET /talks renders 200 with the empty state while only drafts exist", %{conn: conn} do
    conn = get(conn, ~p"/talks")

    assert body = html_response(conn, 200)
    assert body =~ "Nothing here yet. Soon."
  end
end
