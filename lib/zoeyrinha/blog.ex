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

  @doc "All posts, newest first."
  def all_posts, do: @posts

  @doc "All tags across posts, sorted."
  def all_tags, do: @tags

  @doc "The N most recent posts."
  def recent_posts(limit \\ 5), do: Enum.take(@posts, limit)

  @doc "Fetch a post by slug, raising a 404 if missing."
  def get_post_by_id!(id) do
    Enum.find(@posts, &(&1.id == id)) ||
      raise Zoeyrinha.Blog.NotFoundError, "post with id=#{id} not found"
  end
end

defmodule Zoeyrinha.Blog.NotFoundError do
  defexception [:message, plug_status: 404]
end
