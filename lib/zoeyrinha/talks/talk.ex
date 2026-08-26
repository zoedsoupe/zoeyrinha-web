defmodule Zoeyrinha.Talks.Talk do
  @moduledoc "A single talk, workshop or appearance, built from a markdown file by NimblePublisher."

  @enforce_keys [:title, :event, :date, :body]
  defstruct [
    :title,
    :event,
    :location,
    :date,
    :body,
    :image,
    :repo,
    :slides,
    :video,
    draft: false
  ]

  @doc """
  Builds a talk from its frontmatter map and markdown body.

  Files are flat in `priv/talks/*.md`; the date lives in the frontmatter as
  `date: ~D[YYYY-MM-DD]`. The body is the talk's short summary, already
  rendered to HTML by NimblePublisher.
  """
  def build(_filename, attrs, body) do
    struct!(__MODULE__, [body: body] ++ Map.to_list(attrs))
  end
end
