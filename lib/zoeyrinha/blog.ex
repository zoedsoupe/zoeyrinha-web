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
    highlighters: [:makeup_elixir, :makeup_erlang, :makeup_syntect]

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
  Series context for a post: its sibling posts in publication order and the
  post's own position (0-based). Returns `nil` for posts not in a series.
  """
  def series_for(post, locale \\ "en")
  def series_for(%Post{series: nil}, _locale), do: nil

  def series_for(%Post{series: name} = post, locale) do
    posts =
      @posts
      |> Enum.reject(& &1.draft)
      |> Enum.filter(&(&1.series == name))
      |> localize(locale)
      # ponytail: same-day parts ordered by slug; split dates if order matters
      |> Enum.sort(fn a, b ->
        case Date.compare(a.date, b.date) do
          :eq -> a.id <= b.id
          ord -> ord == :lt
        end
      end)

    %{name: name, posts: posts, index: Enum.find_index(posts, &(&1.id == post.id))}
  end

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
