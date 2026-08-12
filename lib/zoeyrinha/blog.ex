defmodule Zoeyrinha.Blog do
  @moduledoc """
  The blog, backed by NimblePublisher.

  Posts live in `priv/posts/YYYY/MM-DD-slug.md` with an Elixir-map frontmatter
  block separated from the body by a line containing only `---`:

      %{
        title: "Hello",
        description: "A short summary used in listings and meta tags.",
        tags: ~w(elixir)
      }
      ---
      Markdown body here.

  Code blocks are highlighted at compile time by Makeup; the token colors are
  mapped to the nyxvamp-veil palette in `assets/css/app.css` (`.makeup .*`).
  """
  alias Zoeyrinha.Blog.Post

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:zoeyrinha, "priv/posts/**/*.md"),
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})
  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  @doc """
  All posts, newest first, localized.

  A post may exist in more than one language (same id, different `lang`).
  Returns one version per id: the requested locale when available, the
  English version otherwise.
  """
  def all_posts(locale \\ "en") do
    @posts |> Enum.reject(& &1.draft) |> localize(locale)
  end

  @doc "All tags across posts, sorted."
  def all_tags, do: @tags

  @doc """
  Fetch a post by slug, preferring the given locale and falling back to
  English. Drafts are invisible here too: a draft slug raises a 404 even
  on a direct URL.
  """
  def get_post_by_id!(id, locale \\ "en") do
    @posts
    |> Enum.reject(& &1.draft)
    |> Enum.filter(&(&1.id == id))
    |> prefer(locale)
    |> Kernel.||(raise(Zoeyrinha.Blog.NotFoundError, "post with id=#{id} not found"))
  end

  defp localize(posts, locale) do
    posts
    |> Enum.group_by(& &1.id)
    |> Enum.map(fn {_id, versions} -> prefer(versions, locale) end)
    |> Enum.sort_by(& &1.date, {:desc, Date})
  end

  defp prefer(versions, locale) do
    Enum.find(versions, &(&1.lang == locale)) ||
      Enum.find(versions, &(&1.lang == "en")) ||
      List.first(versions)
  end
end

defmodule Zoeyrinha.Blog.NotFoundError do
  defexception [:message, plug_status: 404]
end
