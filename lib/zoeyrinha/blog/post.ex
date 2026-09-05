defmodule Zoeyrinha.Blog.Post do
  @moduledoc "A single blog post, built from a markdown file by NimblePublisher."

  @enforce_keys [:id, :title, :body, :description, :tags, :date]
  defstruct [
    :id,
    :title,
    :body,
    :description,
    :tags,
    :date,
    :bsky_thread,
    :image,
    :series,
    :series_index,
    draft: false,
    lang: "en"
  ]

  @doc """
  Builds a post from its path and frontmatter.

  The date and slug come from the path `.../YYYY/MM-DD-slug.md`; the rest of the
  fields come from the frontmatter map. A `.pt-br` suffix before the extension
  marks the pt_BR translation of the post with the same slug:
  `MM-DD-slug.pt-br.md`.
  """
  def build(filename, attrs, body) do
    [year, month_day_id] = filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
    {month_day_id, lang} = split_lang(month_day_id)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")

    struct!(
      __MODULE__,
      [id: id, date: date, body: body, lang: lang] ++ Map.to_list(attrs)
    )
  end

  defp split_lang(name) do
    if String.ends_with?(name, ".pt-br") do
      {String.trim_trailing(name, ".pt-br"), "pt_BR"}
    else
      {name, "en"}
    end
  end
end
