defmodule Zoeyrinha.Talks do
  @moduledoc """
  Talks, workshops and podcast appearances, backed by NimblePublisher.

  Each talk is a markdown file in `priv/talks/*.md` with an Elixir-map
  frontmatter block separated from the body by a line containing only `---`:

      %{
        title: "650k lines in, we killed the validators",
        event: "Elixir em Foco",
        location: "online",
        date: ~D[2026-08-11],
        image: "/images/talks/650k.png",
        repo: "https://github.com/zoedsoupe/peri",
        slides: "https://example.com/slides.pdf",
        video: "https://youtube.com/watch?v=..."
      }
      ---
      Short summary of the talk, rendered as the card body.

  `title`, `event` and `date` are required; every other field is optional.
  `draft: true` hides the talk (e.g. an upcoming talk without materials yet).
  Unlike the blog, talks are not localized: write the file in whichever
  language it was given in.
  """
  alias Zoeyrinha.Talks.Talk

  use NimblePublisher,
    build: Talk,
    from: Application.app_dir(:zoeyrinha, "priv/talks/*.md"),
    as: :talks

  @talks Enum.sort_by(@talks, & &1.date, {:desc, Date})

  @doc "All talks, newest first."
  def all_talks, do: Enum.reject(@talks, & &1.draft)
end
