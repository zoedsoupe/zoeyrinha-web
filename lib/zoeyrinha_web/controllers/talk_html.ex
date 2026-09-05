defmodule ZoeyrinhaWeb.TalkHTML do
  use ZoeyrinhaWeb, :html

  def index(assigns) do
    ~H"""
    <main class="min-h-screen px-4 sm:px-6 lg:px-8 py-16">
      <div class="max-w-3xl mx-auto">
        <header class="mb-12">
          <p class="font-mono text-pink mb-2">/talks</p>
          <h1 class="text-4xl md:text-5xl font-bold text-pink glitch-text">{gettext("talks")}</h1>
          <p class="text-gray-light mt-4">
            {gettext("Talks, workshops and podcast appearances.")}
          </p>
          <%!-- wall(1): write to ALL users. the list below is the stdout --%>
          <p class="mt-6 inline-flex items-center gap-2 border border-selection rounded px-3 py-1.5 font-mono text-sm text-gray-light">
            <span class="text-pink">$</span>
            wall ./talks.txt <span class="cursor-blink text-pink" aria-hidden="true">▊</span>
          </p>
        </header>

        <div :if={@talks == []} class="text-gray-light font-mono">
          {gettext("Nothing here yet. Soon.")}
        </div>

        <ul class="space-y-8">
          <li
            :for={talk <- @talks}
            id={"talk-#{slugify(talk.title)}"}
            class="border-b border-selection pb-8"
          >
            <div class="flex gap-5">
              <div class="min-w-0">
                <time class="font-mono text-sm text-gray-light">
                  {Calendar.strftime(talk.date, "%Y-%m-%d")}
                </time>
                <h2 class="text-2xl font-bold text-pink mt-1">{talk.title}</h2>
                <p class="font-mono text-sm text-gray-light mt-1">
                  {talk.event}<span :if={talk.location}> / {talk.location}</span>
                </p>
                <div class="prose mt-2">{raw(talk.body)}</div>
                <div
                  :if={talk.slides || talk.repo || talk.video}
                  class="flex flex-wrap gap-4 mt-3 font-mono text-sm"
                >
                  <a
                    :if={talk.slides}
                    href={talk.slides}
                    target="_blank"
                    rel="noopener"
                    class="text-pink hover:text-pink-soft transition-colors"
                  >
                    slides
                  </a>
                  <a
                    :if={talk.repo}
                    href={talk.repo}
                    target="_blank"
                    rel="noopener"
                    class="text-pink hover:text-pink-soft transition-colors"
                  >
                    repo
                  </a>
                  <a
                    :if={talk.video}
                    href={talk.video}
                    target="_blank"
                    rel="noopener"
                    class="text-pink hover:text-pink-soft transition-colors"
                  >
                    video
                  </a>
                </div>
                <button
                  type="button"
                  data-share-path={"/talks#talk-#{slugify(talk.title)}"}
                  class="font-mono text-sm text-pink hover:text-pink-soft transition-colors cursor-pointer"
                >
                  <span data-share-label>{gettext("share")}</span>
                  <span data-share-copied hidden>{gettext("copied!")}</span>
                </button>
              </div>
              <img
                :if={talk.image}
                src={talk.image}
                alt=""
                class="w-36 h-36 sm:w-42 sm:h-42 object-cover rounded-full border border-selection shrink-0"
              />
            </div>
          </li>
        </ul>
      </div>
    </main>
    """
  end

  defp slugify(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]+/, "-")
    |> String.trim("-")
  end
end
