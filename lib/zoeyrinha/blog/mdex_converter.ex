defmodule Zoeyrinha.Blog.MDExConverter do
  @moduledoc """
  NimblePublisher html_converter that highlights code fences with Makeup.

  The built-in converter runs the highlighter with a regex that doesn't
  strip comrak's `language-` class prefix, so Makeup never resolves a
  lexer. This one does.

  Comrak options mirror NimblePublisher's defaults (tables, autolinks,
  strikethrough, raw HTML allowed).
  """

  @code_block_regex ~r/<pre><code(?:\s+class="(?:language-)?([^"\s]*)")?>([^<]*)<\/code><\/pre>/

  @comrak_options [
    extension: [table: true, autolink: true, strikethrough: true],
    render: [hardbreaks: false, unsafe: true]
  ]

  @doc "NimblePublisher html_converter callback."
  def convert(_path, body, _attrs, _opts) do
    body
    |> MDExNative.Comrak.markdown_to_html(@comrak_options)
    |> NimblePublisher.highlight(regex: @code_block_regex)
  end
end
