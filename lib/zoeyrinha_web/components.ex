defmodule ZoeyrinhaWeb.Components do
  @moduledoc """
  Provides core UI components with nyxvamp-veil styling.
  """
  use Phoenix.Component
  use Gettext, backend: ZoeyrinhaWeb.Gettext

  @doc """
  Renders a badge component for skills, tags, or tech stack.

  ## Examples

      <.badge>Elixir</.badge>
      <.badge color="blue">TypeScript</.badge>
      <.badge color="green">Phoenix</.badge>
  """
  attr :color, :string,
    default: "pink",
    values: ["pink", "blue", "green", "lavender", "peach", "gray"]

  attr :class, :string, default: ""
  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <span class={[
      "inline-flex items-center px-3 py-1 rounded-full text-sm font-medium transition-colors",
      color_class(@color),
      @class
    ]}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  defp color_class("pink"), do: "bg-pink/20 text-pink border border-pink/30"
  defp color_class("blue"), do: "bg-blue/20 text-blue border border-blue/30"
  defp color_class("green"), do: "bg-green/20 text-green border border-green/30"
  defp color_class("lavender"), do: "bg-lavender/20 text-lavender border border-lavender/30"
  defp color_class("peach"), do: "bg-peach/20 text-peach border border-peach/30"
  defp color_class("gray"), do: "bg-gray/20 text-gray-light border border-gray/30"

  @doc """
  Renders a card component for projects, experience, etc.

  ## Examples

      <.card title="Project Name">
        <p>Project description</p>
      </.card>

      <.card title="Project Name" link="https://github.com/...">
        <p>Project description</p>
      </.card>
  """
  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  attr :link, :string, default: nil
  attr :class, :string, default: ""
  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div class={[
      "bg-cursorline border border-selection rounded-lg p-6 card-hover",
      @class
    ]}>
      <div class="mb-4">
        <%= if @link do %>
          <a href={@link} target="_blank" class="group">
            <h3 class="text-xl font-bold text-pink group-hover:text-pink-soft transition-colors">
              {@title}
            </h3>
          </a>
        <% else %>
          <h3 class="text-xl font-bold text-pink">
            {@title}
          </h3>
        <% end %>
        <%= if @subtitle do %>
          <p class="text-sm text-gray-light mt-1">{@subtitle}</p>
        <% end %>
      </div>
      <div class="text-foreground/90">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  @doc """
  Renders a button component for CTAs.

  ## Examples

      <.button href="/me">About Me</.button>
      <.button variant="secondary" href="/projects">View Projects</.button>
  """
  attr :variant, :string, default: "primary", values: ["primary", "secondary", "outline"]
  attr :href, :string, default: nil
  attr :class, :string, default: ""
  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <%= if @href do %>
      <a
        href={@href}
        class={[
          "inline-flex items-center justify-center px-6 py-3 rounded-lg font-medium transition-all duration-200",
          variant_class(@variant),
          @class
        ]}
      >
        {render_slot(@inner_block)}
      </a>
    <% else %>
      <button class={[
        "inline-flex items-center justify-center px-6 py-3 rounded-lg font-medium transition-all duration-200",
        variant_class(@variant),
        @class
      ]}>
        {render_slot(@inner_block)}
      </button>
    <% end %>
    """
  end

  defp variant_class("primary"), do: "bg-pink text-background hover:bg-pink-soft hover:scale-105"
  defp variant_class("secondary"), do: "bg-blue text-background hover:bg-blue/90 hover:scale-105"

  defp variant_class("outline"),
    do: "border-2 border-pink text-pink hover:bg-pink hover:text-background"

  @doc """
  Renders a navigation bar with language switcher.
  """
  attr :class, :string, default: ""

  def navigation(assigns) do
    ~H"""
    <nav class={["bg-cursorline border-b border-selection py-4", @class]}>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center">
          <div class="flex items-center space-x-8">
            <a href="/" class="text-2xl font-bold text-gradient-pink">
              Zoeyrinha
            </a>
            <div class="hidden md:flex space-x-6">
              <a href="/" class="text-foreground hover:text-pink transition-colors">
                {gettext("Home")}
              </a>
              <a href="/me" class="text-foreground hover:text-pink transition-colors">
                {gettext("About")}
              </a>
              <a
                href="https://github.com/zoedsoupe"
                target="_blank"
                class="text-foreground hover:text-pink transition-colors"
              >
                {gettext("Projects")}
              </a>
            </div>
          </div>

          <%!-- Language Switcher --%>
          <div x-data="languageSwitcher()" class="flex items-center gap-2">
            <button
              @click="switchLocale('en')"
              x-bind:class="{'text-pink': locale === 'en', 'text-gray': locale !== 'en'}"
              class="hover:text-pink transition-colors font-medium px-2 py-1"
            >
              EN
            </button>
            <span class="text-gray">|</span>
            <button
              @click="switchLocale('pt_BR')"
              x-bind:class="{'text-pink': locale === 'pt_BR', 'text-gray': locale !== 'pt_BR'}"
              class="hover:text-pink transition-colors font-medium px-2 py-1"
            >
              PT
            </button>
          </div>
        </div>

        <%!-- Mobile menu toggle (simplified for now) --%>
        <div class="md:hidden mt-4 flex flex-col space-y-2">
          <a href="/" class="text-foreground hover:text-pink transition-colors">
            {gettext("Home")}
          </a>
          <a href="/me" class="text-foreground hover:text-pink transition-colors">
            {gettext("About")}
          </a>
          <a
            href="https://github.com/zoedsoupe"
            target="_blank"
            class="text-foreground hover:text-pink transition-colors"
          >
            {gettext("Projects")}
          </a>
        </div>
      </div>
    </nav>
    """
  end

  @doc """
  Renders a footer component.
  """
  attr :class, :string, default: ""

  def footer(assigns) do
    ~H"""
    <footer class={["bg-cursorline border-t border-selection mt-20 py-8", @class]}>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col items-center space-y-4">
          <.social_links />
          <p class="text-gray text-sm text-center">
            &copy; {DateTime.utc_now().year} ZEETECH. {gettext("All rights reserved")}.
          </p>
          <p class="text-gray text-xs text-center">
            {gettext("Made with")} <span class="text-pink">♥</span> {gettext("in Elixir & Phoenix")}
          </p>
        </div>
      </div>
    </footer>
    """
  end

  @doc """
  Renders social links component with Lucide icons.
  """
  attr :class, :string, default: ""

  def social_links(assigns) do
    ~H"""
    <div class={["flex items-center gap-6", @class]}>
      <a
        href="https://github.com/zoedsoupe"
        target="_blank"
        class="text-foreground hover:text-blue transition-colors"
        aria-label="GitHub"
      >
        <Lucideicons.github class="w-6 h-6" />
      </a>
      <a
        href="https://linkedin.com/in/zoedsoupe"
        target="_blank"
        class="text-foreground hover:text-blue transition-colors"
        aria-label="LinkedIn"
      >
        <Lucideicons.linkedin class="w-6 h-6" />
      </a>
      <a
        href="https://bsky.app/profile/zoedsoupe.zeetech.io"
        target="_blank"
        class="text-foreground hover:text-blue transition-colors"
        aria-label="BlueSky"
      >
        <Lucideicons.cloud class="w-6 h-6" />
      </a>
      <a
        href="https://dev.to/zoedsoupe"
        target="_blank"
        class="text-foreground hover:text-blue transition-colors"
        aria-label="Dev.to"
      >
        <Lucideicons.code class="w-6 h-6" />
      </a>
      <a
        href="mailto:zoey.spessanha@zeetech.io"
        class="text-foreground hover:text-blue transition-colors"
        aria-label="Email"
      >
        <Lucideicons.mail class="w-6 h-6" />
      </a>
    </div>
    """
  end
end
