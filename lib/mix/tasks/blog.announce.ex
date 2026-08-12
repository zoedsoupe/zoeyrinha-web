defmodule Mix.Tasks.Blog.Announce do
  @shortdoc "Announces blog posts missing a bsky_thread on Bluesky"
  @moduledoc """
  Scans priv/posts/**/*.md for posts whose frontmatter has no bsky_thread key,
  publishes an announcement per post ("New post: {title}" + canonical URL with
  a link facet), and writes the resulting AT-URI back into the frontmatter.
  Idempotent: posts that already have bsky_thread are skipped.

  Only the English file of a post is announced; `*.pt-br.md` translations are
  skipped. After announcing, copy the bsky_thread line into the translation's
  frontmatter by hand so both language versions render the same thread.

  Requires BSKY_IDENTIFIER and BSKY_APP_PASSWORD env vars. PHX_HOST overrides
  the canonical host (default zoedsoupe.zeetech.io).
  """
  use Mix.Task

  alias Zoeyrinha.Blog.Frontmatter
  alias Zoeyrinha.Bsky.Client

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start")

    with {:ok, {identifier, password}} <- credentials(),
         {:ok, session} <- Client.login(identifier, password) do
      posts = pending_posts()
      Mix.shell().info("#{length(posts)} post(s) to announce")
      announce_all(session, posts)
    else
      {:error, message} -> Mix.raise(to_string(message))
    end
  end

  defp credentials do
    with identifier when is_binary(identifier) and identifier != "" <-
           System.get_env("BSKY_IDENTIFIER"),
         password when is_binary(password) and password != "" <-
           System.get_env("BSKY_APP_PASSWORD") do
      {:ok, {identifier, password}}
    else
      _ -> {:error, "BSKY_IDENTIFIER and BSKY_APP_PASSWORD must be set (use an app password)"}
    end
  end

  defp pending_posts do
    "priv/posts/**/*.md"
    |> Path.wildcard()
    |> Enum.reject(&String.ends_with?(&1, ".pt-br.md"))
    |> Enum.flat_map(fn path ->
      with {:ok, content} <- File.read(path),
           {:ok, attrs} <- Frontmatter.attrs(content),
           false <- attrs[:draft] || false,
           false <- Map.has_key?(attrs, :bsky_thread),
           title when is_binary(title) <- Map.get(attrs, :title) do
        [{path, title, post_url(path)}]
      else
        true ->
          []

        other ->
          Mix.shell().error("skipping #{path}: #{inspect(other)}")
          []
      end
    end)
  end

  defp announce_all(session, posts) do
    failures =
      Enum.flat_map(posts, fn {path, title, url} ->
        case announce_one(session, path, title, url) do
          :ok -> []
          {:error, reason} -> [{path, reason}]
        end
      end)

    case failures do
      [] ->
        :ok

      _ ->
        details =
          Enum.map_join(failures, "\n", fn {path, reason} -> "  #{path}: #{inspect(reason)}" end)

        Mix.raise("failed to announce #{length(failures)} post(s):\n" <> details)
    end
  end

  defp announce_one(session, path, title, url) do
    with {:ok, at_uri} <- Client.create_post(session, title, url),
         {:ok, content} <- File.read(path),
         {:ok, updated} <- Frontmatter.insert_attr(content, :bsky_thread, at_uri),
         :ok <- File.write(path, updated) do
      Mix.shell().info("announced #{post_id(path)} -> #{at_uri}")
      :ok
    end
  end

  defp post_id(path) do
    path |> Path.basename(".md") |> String.split("-", parts: 3) |> List.last()
  end

  defp post_url(path) do
    host = System.get_env("PHX_HOST") || "zoedsoupe.zeetech.io"
    "https://#{host}/posts/#{post_id(path)}"
  end
end
