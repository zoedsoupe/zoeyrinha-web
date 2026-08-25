defmodule ZoeyrinhaWeb.Components do
  @moduledoc """
  Core UI components. Minimal, dark, zeetech-derived palette.
  """
  use Phoenix.Component
  use Gettext, backend: ZoeyrinhaWeb.Gettext

  @doc """
  A small monochrome tag, used for post tags.

      <.badge>elixir</.badge>
  """
  attr :class, :string, default: ""
  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <span class={[
      "inline-flex items-center rounded-full border border-selection px-2.5 py-0.5",
      "font-mono text-xs text-gray-light",
      @class
    ]}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc "Top navigation with a language switcher."
  attr :class, :string, default: ""

  def navigation(assigns) do
    ~H"""
    <nav class={["border-b border-selection", @class]}>
      <div class="mx-auto max-w-2xl px-5 py-4 flex justify-between items-center">
        <div class="flex items-center gap-6">
          <a href="/" class="font-mono font-bold text-pink glitch-text">/zoeyrinha</a>
          <div class="hidden sm:flex gap-5 font-mono text-sm">
            <a href="/" class="text-gray-light hover:text-pink transition-colors">
              {gettext("home")}
            </a>
            <a href="/posts" class="text-gray-light hover:text-pink transition-colors">
              {gettext("blog")}
            </a>
            <a href="/cv" class="text-gray-light hover:text-pink transition-colors">
              cv
            </a>
            <a
              href="https://zeetech.io"
              target="_blank"
              rel="noopener"
              class="text-gray-light hover:text-pink transition-colors"
            >
              zeetech
            </a>
          </div>
        </div>

        <%!-- Language switcher --%>
        <div x-data="languageSwitcher()" class="flex items-center gap-1 font-mono text-sm">
          <button
            @click="switchLocale('en')"
            x-bind:class="{'text-pink': locale === 'en', 'text-gray': locale !== 'en'}"
            class="cursor-pointer hover:text-pink transition-colors px-1"
          >
            en
          </button>
          <span class="text-gray">/</span>
          <button
            @click="switchLocale('pt_BR')"
            x-bind:class="{'text-pink': locale === 'pt_BR', 'text-gray': locale !== 'pt_BR'}"
            class="cursor-pointer hover:text-pink transition-colors px-1"
          >
            pt
          </button>
        </div>
      </div>
    </nav>
    """
  end

  @doc """
  Fixed bottom button bar, mobile only. Desktop keeps links in the top nav.
  """
  attr :current_path, :string, required: true

  def bottom_nav(assigns) do
    ~H"""
    <nav class="sm:hidden fixed bottom-0 inset-x-0 z-50 border-t border-selection bg-background">
      <div class="flex justify-around items-stretch font-mono text-xs pb-[env(safe-area-inset-bottom)]">
        <.bottom_nav_link href="/" icon="home" label={gettext("home")} current_path={@current_path} />
        <.bottom_nav_link
          href="/posts"
          icon="book-open"
          label={gettext("blog")}
          current_path={@current_path}
        />
        <.bottom_nav_link href="/cv" icon="file-text" label="cv" current_path={@current_path} />
        <a
          href="https://zeetech.io"
          target="_blank"
          rel="noopener"
          class="flex flex-col items-center gap-1 py-2 px-4 text-gray-light"
        >
          <Lucideicons.external_link class="w-5 h-5" /> zeetech
        </a>
      </div>
    </nav>
    """
  end

  attr :href, :string, required: true
  attr :icon, :string, required: true
  attr :label, :string, required: true
  attr :current_path, :string, required: true

  defp bottom_nav_link(assigns) do
    active =
      if assigns.href == "/",
        do: assigns.current_path == "/",
        else: String.starts_with?(assigns.current_path, assigns.href)

    assigns = assign(assigns, :active, active)

    ~H"""
    <a
      href={@href}
      aria-current={@active && "page"}
      class={[
        "flex flex-col items-center gap-1 py-2 px-4",
        if(@active, do: "text-pink", else: "text-gray-light")
      ]}
    >
      <%= case @icon do %>
        <% "home" -> %>
          <Lucideicons.home class="w-5 h-5" />
        <% "book-open" -> %>
          <Lucideicons.book_open class="w-5 h-5" />
        <% "file-text" -> %>
          <Lucideicons.file_text class="w-5 h-5" />
      <% end %>
      {@label}
    </a>
    """
  end

  @doc "Small tip-jar card linking GitHub Sponsors and Buy Me a Coffee."
  attr :class, :string, default: ""

  def support(assigns) do
    ~H"""
    <aside class={["rounded border border-selection p-5", @class]}>
      <p class="text-gray-light text-sm mb-4">
        {gettext("no ads, no sponsors, no metrics. if this helped you, here's the tip jar.")}
      </p>
      <div class="flex flex-wrap gap-5 font-mono text-sm">
        <a
          href="https://github.com/sponsors/zoedsoupe"
          target="_blank"
          rel="noopener"
          class="inline-flex items-center gap-2 text-gray-light hover:text-pink transition-colors"
        >
          <Lucideicons.heart class="w-4 h-4" /> github sponsors
        </a>
        <a
          href="https://buymeacoffee.com/zoedsoupe"
          target="_blank"
          rel="noopener"
          class="inline-flex items-center gap-2 text-gray-light hover:text-pink transition-colors"
        >
          <Lucideicons.coffee class="w-4 h-4" /> buy me a coffee
        </a>
      </div>
    </aside>
    """
  end

  @doc "Minimal site footer."
  attr :class, :string, default: ""

  def footer(assigns) do
    ~H"""
    <footer class={["border-t border-selection mt-12 py-8", @class]}>
      <div class="mx-auto max-w-2xl px-5 flex flex-col items-start gap-4">
        <.social_links />
        <p class="font-mono text-xs text-gray">
          &copy; {DateTime.utc_now().year} zoey de souza pessanha / zeetech
        </p>
      </div>
    </footer>
    """
  end

  @doc "Social links rendered with Lucide icons."
  attr :class, :string, default: ""

  def social_links(assigns) do
    ~H"""
    <div class={["flex items-center gap-5", @class]}>
      <a
        href="https://github.com/zoedsoupe"
        target="_blank"
        rel="noopener"
        class="text-gray-light hover:text-pink transition-colors"
        aria-label="GitHub"
      >
        <Lucideicons.github class="w-5 h-5" />
      </a>
      <a
        href="https://linkedin.com/in/zoedsoupe"
        target="_blank"
        rel="noopener"
        class="text-gray-light hover:text-pink transition-colors"
        aria-label="LinkedIn"
      >
        <Lucideicons.linkedin class="w-5 h-5" />
      </a>
      <a
        href="https://bsky.app/profile/zoedsoupe.zeetech.io"
        target="_blank"
        rel="noopener"
        class="text-gray-light hover:text-pink transition-colors"
        aria-label="Bluesky"
      >
        <Lucideicons.cloud class="w-5 h-5" />
      </a>
      <a
        href="mailto:zoey.spessanha@zeetech.io"
        class="text-gray-light hover:text-pink transition-colors"
        aria-label="Email"
      >
        <Lucideicons.mail class="w-5 h-5" />
      </a>
    </div>
    """
  end
end
