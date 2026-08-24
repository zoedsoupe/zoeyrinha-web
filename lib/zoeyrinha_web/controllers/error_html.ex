defmodule ZoeyrinhaWeb.ErrorHTML do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on HTML requests.

  See config/config.exs.
  """
  use ZoeyrinhaWeb, :html

  embed_templates "error_html/*"

  # Fall back to a plain status message for statuses without a template.
  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
