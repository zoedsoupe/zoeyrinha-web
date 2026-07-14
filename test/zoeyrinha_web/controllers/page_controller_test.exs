defmodule ZoeyrinhaWeb.PageControllerTest do
  use ZoeyrinhaWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "senior software engineer"
  end
end
