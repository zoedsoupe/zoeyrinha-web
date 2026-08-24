defmodule ZoeyrinhaWeb.ErrorHTMLTest do
  use ZoeyrinhaWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    html = render_to_string(ZoeyrinhaWeb.ErrorHTML, "404", "html", [])
    assert html =~ "<h1>404</h1>"
    assert html =~ "this page doesn't exist"
  end

  test "renders 500.html" do
    html = render_to_string(ZoeyrinhaWeb.ErrorHTML, "500", "html", [])
    assert html =~ "<h1>500</h1>"
    assert html =~ "something broke on my side"
  end

  test "falls back to status message for statuses without a template" do
    assert render_to_string(ZoeyrinhaWeb.ErrorHTML, "403", "html", []) == "Forbidden"
  end
end
