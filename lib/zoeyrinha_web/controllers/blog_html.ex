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
      </article>
    </main>
    """
  end

  @doc "Rough reading time in minutes, at ~200 words per minute."
  def reading_time(body) do
    words = body |> String.split(~r/\s+/, trim: true) |> length()
    max(div(words, 200), 1)
  end
end
