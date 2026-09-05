defmodule Zoeyrinha.Blog.MDExConverter do
  @moduledoc """
  NimblePublisher html_converter backed by MDEx (comrak) instead of Earmark.

  MDEx emits code blocks as `<pre><code class="language-elixir">…`; the
  highlight regex strips the `language-` prefix so Makeup resolves the lexer
  by its bare name.
  """

  @code_block_regex ~r/<pre><code(?:\s+class="(?:language-)?([^"\s]*)")?>([^<]*)<\/code><\/pre>/

  @doc "NimblePublisher html_converter callback."
  def convert(_path, body, _attrs, _opts) do
    body
    |> MDEx.to_html!()
    |> NimblePublisher.highlight(regex: @code_block_regex)
  end
end
