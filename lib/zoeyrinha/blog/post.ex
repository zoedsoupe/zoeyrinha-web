defmodule Zoeyrinha.Blog.Post do
  @moduledoc "A single blog post, built from a markdown file by NimblePublisher."

  @enforce_keys [:id, :title, :body, :description, :tags, :date]
  defstruct [:id, :title, :body, :description, :tags, :date]

  @doc """
  Builds a post from its path and frontmatter.

  The date and slug come from the path `.../YYYY/MM-DD-slug.md`; the rest of the
  fields come from the frontmatter map.
  """
  def build(filename, attrs, body) do
    [year, month_day_id] = filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    struct!(__MODULE__, [id: id, date: date, body: body] ++ Map.to_list(attrs))
  end
end
