defmodule Zoeyrinha.CV do
  @moduledoc """
  Serves my CV from markdown files in `priv/cv` (`cv_en.md`, `cv_pt_br.md`).

  Files are read at runtime and cached in `:persistent_term` keyed by
  mtime, so editing the markdown reflects on the site with no recompile
  or redeploy.
  """

  @doc """
  Rendered CV HTML for the given locale (`"pt_BR"` or `"en"`).
  Raises `Zoeyrinha.CV.NotFoundError` (404) when the file is missing.
  """
  @spec html(String.t()) :: String.t()
  def html(locale) do
    path = Path.join([:code.priv_dir(:zoeyrinha), "cv", filename(locale)])

    case File.stat(path, time: :posix) do
      {:ok, %{mtime: mtime}} ->
        case :persistent_term.get({__MODULE__, locale}, nil) do
          {^mtime, html} -> html
          _stale -> load(path, locale, mtime)
        end

      {:error, _reason} ->
        raise Zoeyrinha.CV.NotFoundError, "cv file not found: #{path}"
    end
  end

  @comrak_options [
    extension: [table: true, autolink: true, strikethrough: true],
    render: [hardbreaks: false, unsafe: true]
  ]

  defp load(path, locale, mtime) do
    html = path |> File.read!() |> MDExNative.Comrak.markdown_to_html(@comrak_options)
    :persistent_term.put({__MODULE__, locale}, {mtime, html})
    html
  end

  defp filename("pt_BR"), do: "cv_pt_br.md"
  defp filename(_other), do: "cv_en.md"
end

defmodule Zoeyrinha.CV.NotFoundError do
  defexception [:message, plug_status: 404]
end
