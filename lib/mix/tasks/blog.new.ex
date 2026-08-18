defmodule Mix.Tasks.Blog.New do
  @moduledoc """
  Scaffolds a new blog post in `priv/posts/` and opens it in `$EDITOR`.

      mix blog.new

  Without arguments the task asks for everything: which language version(s)
  to create (en, pt-br, or both), and the title and description for each
  one. Titles and descriptions are asked per language because translations
  are written by hand, not generated.

  Every prompt can be pre-answered with an option:

      mix blog.new "my post title" \\
        --description "one-line summary" \\
        --lang both \\
        --tags elixir,oss \\
        --series peri

  Options:

    * `--lang` - `en`, `pt-br`, or `both`. Asked when omitted.
    * `--description` - description for the English post. Asked when omitted
      and an English file is being created. For pt-br-only posts use
      `--description-pt-br`.
    * `--description-pt-br` - description for the pt-br post.
    * `--title-pt-br` - title for the pt-br post. Asked when omitted. When
      `--lang pt-br`, the positional title is used instead.
    * `--tags` - comma or space separated, e.g. `--tags elixir,peri,oss`.
      Optional.
    * `--series` - series slug, e.g. `--series peri`. Optional.
    * `--no-open` - do not open `$EDITOR` after creating the files.

  The positional title is the English one when both languages are created,
  and the pt-br one when only pt-br is created. With `--lang both`, the
  pt-br title comes from `--title-pt-br` or a prompt, since it is never
  the same string.

  Files are created as `priv/posts/YYYY/MM-DD-slug.md` and, when requested,
  `MM-DD-slug.pt-br.md`: the same layout NimblePublisher expects. The
  `bsky_thread` field is intentionally left out: `mix blog.announce` fills
  it in after the post is live.

  Typical flow:

      mix blog.new
      # write the post
      git add -A && git commit -m "feat(blog): add my post" && git push

  The push triggers the Fly deploy; the announce workflow then posts to
  Bluesky and commits the thread URI back into the frontmatter.
  """

  use Mix.Task

  @shortdoc "Scaffold a new blog post and open $EDITOR"

  @switches [
    lang: :string,
    description: :string,
    description_pt_br: :string,
    title_pt_br: :string,
    tags: :string,
    series: :string,
    no_open: :boolean
  ]

  @impl true
  def run(argv) do
    {opts, args, _} = OptionParser.parse(argv, strict: @switches)

    lang = opts[:lang] || prompt_lang()
    unless lang in ~w(en pt-br both), do: Mix.raise("--lang must be en, pt-br, or both")

    date = Date.utc_today()

    posts =
      for l <- lang_versions(lang) do
        # with --lang both the positional title is the English one, so only
        # hand it to the pt-br prompt path when pt-br is the sole language
        title_args = if l == "en" or lang == "pt-br", do: args, else: []
        {l, title_and_description(l, title_args, opts)}
      end

    # both language files share one slug (the pt-br file is the translation
    # of the same post); prefer the English title as the slug source
    slug_source = List.keyfind(posts, "en", 0) || hd(posts)
    slug = slug_source |> elem(1) |> elem(0) |> slug()

    files =
      for {l, {title, description}} <- posts do
        path = post_path(date, slug, l)
        write_post(path, title, description, opts)
        path
      end

    unless opts[:no_open] do
      editor = System.get_env("EDITOR") || "vim"
      # System.cmd pipes stdio, which full-screen editors (helix) reject;
      # hand the editor the real terminal via /dev/tty
      System.cmd("sh", ["-c", "#{editor} #{Enum.join(files, " ")} < /dev/tty > /dev/tty"])
    end

    Mix.shell().info("\nCreated #{Enum.join(files, ", ")}")
  end

  defp lang_versions("en"), do: ["en"]
  defp lang_versions("pt-br"), do: ["pt-br"]
  defp lang_versions("both"), do: ["en", "pt-br"]

  defp title_and_description("en", args, opts) do
    title = List.first(args) || Mix.shell().prompt("Title (en):") |> String.trim()
    description = opts[:description] || Mix.shell().prompt("Description (en):") |> String.trim()
    {title, description}
  end

  defp title_and_description("pt-br", args, opts) do
    title =
      opts[:title_pt_br] || List.first(args) ||
        Mix.shell().prompt("Título (pt-br):") |> String.trim()

    description =
      opts[:description_pt_br] || Mix.shell().prompt("Descrição (pt-br):") |> String.trim()

    {title, description}
  end

  defp prompt_lang do
    answer =
      Mix.shell().prompt("Language? [en / pt-br / both]")
      |> String.trim()
      |> String.downcase()

    if answer in ~w(en pt-br both), do: answer, else: prompt_lang()
  end

  defp slug(title) do
    title
    |> String.normalize(:nfd)
    |> String.replace(~r/[^A-Za-z0-9\s-]/, "")
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]+/, "-")
    |> String.trim("-")
  end

  defp post_path(date, slug, lang) do
    suffix = if lang == "pt-br", do: ".pt-br.md", else: ".md"
    dir = Path.join(["priv", "posts", to_string(date.year)])
    File.mkdir_p!(dir)

    path = Path.join(dir, "#{Calendar.strftime(date, "%m-%d")}-#{slug}#{suffix}")

    if File.exists?(path), do: Mix.raise("#{path} already exists")

    path
  end

  defp write_post(path, title, description, opts) do
    File.write!(path, frontmatter(title, description, opts))
  end

  defp frontmatter(title, description, opts) do
    series = if opts[:series], do: ~s(series: "#{opts[:series]}",\n), else: ""
    tags = if opts[:tags], do: String.split(opts[:tags], ~r/[,\s]+/, trim: true), else: []

    """
    %{
    title: "#{title}",
    description: "#{description}",
    tags: ~w(#{Enum.join(tags, " ")}),
    #{series}
    }
    ---

    """
  end
end
