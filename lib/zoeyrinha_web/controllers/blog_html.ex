defmodule ZoeyrinhaWeb.BlogHTML do
  use ZoeyrinhaWeb, :html

  def index(assigns) do
    ~H"""
    <main class="min-h-screen px-4 sm:px-6 lg:px-8 py-16">
      <div class="max-w-3xl mx-auto">
        <header class="mb-12">
          <p class="font-mono text-pink mb-2">/posts</p>
          <h1 class="text-4xl md:text-5xl font-bold text-pink glitch-text">blog</h1>
          <p class="text-gray-light mt-4">
            {gettext("Notes on Elixir, distributed systems, and whatever else I am chewing on.")}
          </p>
        </header>

        <div :if={@posts == []} class="text-gray-light font-mono">
          {gettext("Nothing here yet. Soon.")}
        </div>

        <ul class="space-y-8">
          <li :for={post <- @posts} class="border-b border-selection pb-8">
            <a href={~p"/posts/#{post.id}"} class="group block">
              <time class="font-mono text-sm text-gray-light">
                {Calendar.strftime(post.date, "%Y-%m-%d")}
              </time>
              <h2 class="text-2xl font-bold text-pink group-hover:text-pink-soft transition-colors mt-1">
                {post.title}
              </h2>
              <p class="text-foreground/90 mt-2">{post.description}</p>
            </a>
            <div class="flex flex-wrap items-center gap-2 mt-3">
              <.badge :for={tag <- post.tags}>{tag}</.badge>
              <span class="font-mono text-xs text-gray ml-auto">
                {reading_time(post.body)} {gettext("min read")}
              </span>
            </div>
          </li>
        </ul>
      </div>
    </main>
    """
  end

  def show(assigns) do
    ~H"""
    <main class="min-h-screen px-4 sm:px-6 lg:px-8 py-16">
      <article class="max-w-3xl mx-auto">
        <header class="mb-8 pb-8 border-b border-selection">
          <a href={~p"/posts"} class="font-mono text-sm text-pink hover:text-pink-soft">
            &larr; {gettext("all posts")}
          </a>
          <h1 class="text-3xl md:text-4xl font-bold text-pink mt-4">{@post.title}</h1>
          <div class="flex flex-wrap items-center gap-3 mt-4 font-mono text-sm text-gray-light">
            <time>{Calendar.strftime(@post.date, "%Y-%m-%d")}</time>
            <span class="text-gray">/</span>
            <span>{reading_time(@post.body)} {gettext("min read")}</span>
          </div>
          <div class="flex flex-wrap gap-2 mt-4">
            <.badge :for={tag <- @post.tags}>{tag}</.badge>
          </div>
        </header>

        <div class="prose">
          {raw(@post.body)}
        </div>

        <section :if={@comments != :none} class="mt-16 pt-8 border-t border-selection">
          <h2 class="text-2xl font-bold text-pink mb-4">{gettext("comments")}</h2>
          <p class="font-mono text-sm mb-6">
            <a
              href={@thread_url}
              target="_blank"
              rel="noopener"
              class="text-pink hover:text-pink-soft"
            >
              {gettext("reply on Bluesky")}
            </a>
          </p>

          <div :if={@comments == :error} class="text-gray-light">
            {gettext("Comments are unavailable right now.")}
            <a href={@thread_url} target="_blank" rel="noopener" class="text-pink">
              {gettext("Read the thread on Bluesky.")}
            </a>
          </div>

          <p :if={@comments == []} class="text-gray-light font-mono text-sm">
            {gettext("No comments yet.")}
          </p>

          <ol :if={is_list(@comments)} class="space-y-6">
            <.comment :for={comment <- @comments} comment={comment} />
          </ol>
        </section>
      </article>
    </main>
    """
  end

  attr :comment, Zoeyrinha.Blog.Comment, required: true

  def comment(assigns) do
    ~H"""
    <li>
      <article>
        <header class="flex items-center gap-2 text-sm">
          <img
            :if={@comment.author_avatar}
            src={@comment.author_avatar}
            alt=""
            class="h-6 w-6 rounded-full"
          />
          <span class="text-foreground">{@comment.author_display_name || @comment.author_handle}</span>
          <a
            :if={@comment.author_did}
            href={"https://bsky.app/profile/#{@comment.author_did}"}
            target="_blank"
            rel="noopener"
            class="font-mono text-gray-light"
          >
            @{@comment.author_handle}
          </a>
          <time :if={@comment.created_at} class="font-mono text-gray-light ml-auto">
            {Calendar.strftime(@comment.created_at, "%Y-%m-%d %H:%M")}
          </time>
        </header>

        <p class="whitespace-pre-wrap mt-2 text-foreground/90">
          <.segment :for={segment <- @comment.segments} segment={segment} />
        </p>

        <footer class="flex gap-4 mt-2 font-mono text-xs text-gray-light">
          <span>{@comment.like_count} likes</span>
          <span>{@comment.reply_count} replies</span>
          <a :if={@comment.url} href={@comment.url} target="_blank" rel="noopener" class="text-pink">
            view on Bluesky
          </a>
        </footer>
      </article>

      <ol :if={@comment.replies != []} class="mt-4 ml-4 pl-4 border-l border-selection space-y-6">
        <.comment :for={reply <- @comment.replies} comment={reply} />
      </ol>
    </li>
    """
  end

  attr :segment, :any, required: true

  defp segment(%{segment: {:text, _text}} = assigns) do
    ~H"{elem(@segment, 1)}"
  end

  defp segment(%{segment: {:link, _text, _url}} = assigns) do
    ~H"""
    <a href={elem(@segment, 2)} target="_blank" rel="noopener" class="text-pink">{elem(@segment, 1)}</a>
    """
  end

  defp segment(%{segment: {:mention, _text, _did}} = assigns) do
    ~H"""
    <a
      href={"https://bsky.app/profile/#{elem(@segment, 2)}"}
      target="_blank"
      rel="noopener"
      class="text-pink"
    >{elem(@segment, 1)}</a>
    """
  end

  @doc "Rough reading time in minutes, at ~200 words per minute."
  def reading_time(body) do
    words = body |> String.split(~r/\s+/, trim: true) |> length()
    max(div(words, 200), 1)
  end
end
