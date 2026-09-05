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

          <div class="mt-6 flex flex-wrap items-center gap-3">
            <a
              href="/rss.xml"
              title={gettext("rss feed")}
              class="inline-flex items-center gap-2 border border-selection rounded px-3 py-1.5 font-mono text-sm text-gray-light hover:text-pink hover:border-pink transition-colors"
            >
              <span class="text-pink">$</span>
              curl -s zoedsoupe.zeetech.io/rss.xml | less
              <span class="cursor-blink text-pink" aria-hidden="true">▊</span>
            </a>
            <button
              type="button"
              data-share-path="/rss.xml"
              class="font-mono text-xs text-pink hover:text-pink-soft transition-colors cursor-pointer"
            >
              <span data-share-label>{gettext("copy feed url")}</span>
              <span data-share-copied hidden>{gettext("copied!")}</span>
            </button>
          </div>
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
              <span
                :if={post.lang != @locale}
                class="font-mono text-xs text-gray ml-2"
                title={gettext("not yet translated to your language")}
              >
                [{if post.lang == "en", do: "en", else: "pt-br"}]
              </span>
              <h2 class="text-2xl font-bold text-pink group-hover:text-pink-soft transition-colors mt-1">
                {post.title}
              </h2>
              <p class="text-foreground/90 mt-2">{post.description}</p>
            </a>
            <div class="flex flex-wrap items-center gap-2 mt-3">
              <a
                :if={first = @series_first[post.id]}
                href={~p"/posts/#{first}"}
                class="font-mono text-xs text-pink hover:text-pink-soft"
              >
                {gettext("series")}: {post.series} -&gt;
              </a>
              <.badge :for={tag <- post.tags}>{tag}</.badge>
              <button
                type="button"
                data-share-path={"/posts/#{post.id}"}
                class="font-mono text-xs text-pink hover:text-pink-soft transition-colors cursor-pointer"
              >
                <span data-share-label>{gettext("share")}</span>
                <span data-share-copied hidden>{gettext("copied!")}</span>
              </button>
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
            -&gt; {gettext("all posts")}
          </a>
          <h1 class="text-3xl md:text-4xl font-bold text-pink mt-4">{@post.title}</h1>
          <div class="flex flex-wrap items-center gap-3 mt-4 font-mono text-sm text-gray-light">
            <time>{Calendar.strftime(@post.date, "%Y-%m-%d")}</time>
            <span class="text-gray">/</span>
            <span>{reading_time(@post.body)} {gettext("min read")}</span>
            <span class="text-gray">/</span>
            <button
              type="button"
              data-share-path={"/posts/#{@post.id}"}
              class="text-pink hover:text-pink-soft transition-colors cursor-pointer"
            >
              <span data-share-label>{gettext("share")}</span>
              <span data-share-copied hidden>{gettext("copied!")}</span>
            </button>
          </div>
          <div class="flex flex-wrap gap-2 mt-4">
            <.badge :for={tag <- @post.tags}>{tag}</.badge>
          </div>
          <p :if={@post.lang != @locale} class="font-mono text-xs text-gray-light mt-4">
            {if @post.lang == "en",
              do: gettext("this post is only available in english"),
              else: gettext("this post is only available in português")}
          </p>
        </header>

        <.series_nav :if={@series} series={@series} current_id={@post.id} class="mb-10" />

        <div class="prose">
          {raw(@post.body)}
        </div>

        <.support class="mt-16" />

        <section :if={@post.bsky_thread} class="mt-16 pt-8 border-t border-selection">
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

          {live_render(@conn, ZoeyrinhaWeb.CommentsLive,
            id: "comments",
            session: %{"at_uri" => @post.bsky_thread, "locale" => @locale}
          )}
        </section>
      </article>
    </main>
    """
  end

  attr :series, :map, required: true
  attr :current_id, :string, required: true
  attr :class, :string, default: nil

  def series_nav(assigns) do
    ~H"""
    <nav class={[
      "border border-selection rounded font-mono text-sm",
      @class
    ]}>
      <header class="px-4 py-2 border-b border-selection text-pink">
        {gettext("series")}: {@series.name}
        <span class="text-gray-light">
          - {gettext("part %{n} of %{total}",
            n: @series.index + 1,
            total: length(@series.posts)
          )}
        </span>
      </header>
      <ol class="px-4 py-3 space-y-1.5">
        <li :for={{part, i} <- Enum.with_index(@series.posts, 1)}>
          <a
            :if={part.id != @current_id}
            href={~p"/posts/#{part.id}"}
            class="text-gray-light hover:text-pink transition-colors"
          >
            <span class="text-gray">{i}.</span> {part.title}
          </a>
          <span :if={part.id == @current_id} class="text-pink">
            <span class="text-gray">{i}.</span> {part.title}
            <span aria-hidden="true">&lt- cê tá aqui oh</span>
          </span>
        </li>
      </ol>
    </nav>
    """
  end

  @doc "Rough reading time in minutes, at ~200 words per minute."
  def reading_time(body) do
    words = body |> String.split(~r/\s+/, trim: true) |> length()
    max(div(words, 200), 1)
  end
end
