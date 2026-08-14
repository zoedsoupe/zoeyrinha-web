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

      <%!-- Mobile links row --%>
      <div class="sm:hidden border-t border-selection">
        <div class="mx-auto max-w-2xl px-5 py-3 flex gap-5 font-mono text-sm">
          <a href="/" class="text-gray-light hover:text-pink transition-colors">
            {gettext("home")}
          </a>
          <a href="/posts" class="text-gray-light hover:text-pink transition-colors">
            {gettext("blog")}
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
    </nav>
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
