defmodule ZoeyrinhaWeb.LandingHTML do
  use ZoeyrinhaWeb, :html

  # Highlighted at compile time with the same Makeup pipeline the blog uses.
  @zoey_code Makeup.highlight(~S'''
             def zoey do
               %{
                 name: "zoey de souza pessanha",
                 pronouns: ~w(she they),
                 location: "campos dos goytacazes, rj, br",
                 identity: ~w(travesty transfem gothic),
                 passions: ~w(functional_programming open_source
                              abstract_algebra community_building),
                 music: ~w(numetal industrial_metal goth_metal emo),
                 tools: ~w(elixir haskell clojure nixos helix),
                 believes_in: "the functional way is the right way"
               }
             end
             ''')

  def show(assigns) do
    ~H"""
    <main class="mx-auto max-w-2xl px-5 py-16 sm:py-24">
      <%!-- Hero --%>
      <header class="flex items-center gap-5 mb-10">
        <img
          src={~p"/images/profile.jpeg"}
          alt="zoey"
          class="w-20 h-20 sm:w-24 sm:h-24 rounded-full border border-selection shrink-0"
        />
        <div>
          <h1 class="text-2xl sm:text-3xl font-bold text-foreground">
            {gettext("hey, i'm zoey(rinha)")}
          </h1>
          <p class="font-mono text-sm text-pink glitch-text">/zoeyrinha</p>
          <p class="text-gray-light text-sm mt-2">
            {gettext("senior software engineer. oss maintainer. elixir em foco co-host.")}
          </p>
        </div>
      </header>

      <div class="makeup mb-16 text-sm">{raw(zoey_code())}</div>

      <%!-- This place --%>
      <section class="space-y-4 mb-16">
        <h2 class="font-mono text-sm text-pink mb-2 glitch-text">
          {gettext("// this place")}
        </h2>
        <p>
          {gettext(
            "this site is my corner of the internet. no feed, no algorithm, no engagement metrics. just words i wanted to write and code i wanted to share, served straight from a little elixir app."
          )}
        </p>
        <p>
          {gettext(
            "i'm a travesty engineer from campos dos goytacazes, brazil. i fell in love with functional programming years ago and never looked back. these days i build knowledge systems by day, maintain open source by night, and co-host Elixir em Foco, brazil's first elixir podcast."
          )}
        </p>
        <p>
          {gettext(
            "my philosophy is simple: if it can be pure, make it pure. if it can be composable, make it composable. if it can help someone, make it open source."
          )}
        </p>
      </section>

      <%!-- Blog --%>
      <section class="mb-16">
        <h2 class="font-mono text-sm text-pink mb-2 glitch-text">{gettext("// the blog")}</h2>
        <p>
          {gettext(
            "the main dish of this place. long-form notes on elixir, OTP and distributed systems, plus the occasional rant about software, society and everything in between. no schedule, no content strategy, no growth hacking."
          )}
        </p>
        <h3 class="font-mono text-sm text-pink mt-5">{gettext("// what i've been writing")}</h3>
        <ul :if={@recent_posts != []} class="space-y-3 mt-3">
          <li :for={post <- @recent_posts}>
            <a href={~p"/posts/#{post.id}"} class="group block">
              <time class="font-mono text-xs text-gray-light">
                {Calendar.strftime(post.date, "%Y-%m-%d")}
              </time>
              <p class="text-foreground group-hover:text-pink transition-colors">
                {post.title}
              </p>
            </a>
          </li>
        </ul>
        <p class="font-mono text-sm mt-3">
          <a href={~p"/posts"}>{gettext("read the blog")} -&gt;</a>
        </p>
      </section>

      <%!-- What i'm into --%>
      <section class="mb-16">
        <h2 class="font-mono text-sm text-pink mb-5 glitch-text">{gettext("// what i'm into")}</h2>
        <div class="space-y-4">
          <.into label={gettext("music that moves me")}>
            {gettext(
              "from industrial metal to dark psytrance to brazilian funk. music is how i process the world."
            )}
          </.into>
          <.into label={gettext("deconstructing society")}>
            {gettext(
              "how we build and rebuild concepts like religion and gender, and the systems that shape us."
            )}
          </.into>
          <.into label={gettext("building communities")}>
            {gettext(
              "tech is better when we build it together, from podcasts to open source to helping artisanal fishing communities go digital."
            )}
          </.into>
          <.into label={gettext("elixir and math, made approachable")}>
            {gettext("there is poetry in patterns, even when the proofs still escape me.")}
          </.into>
        </div>
      </section>

      <%!-- Things i maintain --%>
      <section class="mb-16">
        <h2 class="font-mono text-sm text-pink mb-2 glitch-text">
          {gettext("// things i maintain")}
        </h2>
        <p class="mb-5">
          {gettext("open source is how i pay rent to the commons. a few of my kids:")}
        </p>
        <ul class="space-y-4">
          <.project name="anubis-mcp" href="https://github.com/zoedsoupe/anubis-mcp">
            {gettext(
              "Model Context Protocol SDK in Elixir. transports, sessions, OTP all the way down."
            )}
          </.project>
          <.project name="supabase-ex" href="https://github.com/zoedsoupe/supabase-ex">
            {gettext("the Supabase ecosystem in Elixir: auth, storage, postgrest, realtime.")}
          </.project>
          <.project name="peri" href="https://github.com/zoedsoupe/peri">
            {gettext("schema validation by pattern matching, not macros.")}
          </.project>
          <.project name="exlings" href="https://github.com/zoedsoupe/exlings">
            {gettext("learn Elixir by fixing broken code, in the spirit of rustlings.")}
          </.project>
          <.project name="proto_rune" href="https://github.com/zoedsoupe/proto_rune">
            {gettext("AT Protocol and Bluesky SDK, with a session that refreshes itself.")}
          </.project>
        </ul>
        <p class="mt-5 font-mono text-sm">
          <a href="https://github.com/zoedsoupe" target="_blank" rel="noopener">
            {gettext("more on github")} -&gt;
          </a>
        </p>
      </section>

      <%!-- Support --%>
      <section class="mb-16">
        <h2 class="font-mono text-sm text-pink mb-5 glitch-text">
          {gettext("// support this corner")}
        </h2>
        <.support />
      </section>

      <%!-- Elsewhere --%>
      <section>
        <h2 class="font-mono text-sm text-pink mb-4 glitch-text">{gettext("// elsewhere")}</h2>
        <p class="text-gray-light mb-4">
          {gettext(
            "i'm not really into social networks anymore. i think we are heading the wrong way as a society under this economic system. but you can find me around:"
          )}
        </p>
        <ul class="font-mono text-sm space-y-2">
          <li>
            <a href="https://elixiremfoco.com" target="_blank" rel="noopener">elixir em foco</a>
            <span class="text-gray-light">{gettext("the podcast")}</span>
          </li>
          <li>
            <a href="https://bsky.app/profile/zoedsoupe.zeetech.io" target="_blank" rel="noopener">
              bluesky
            </a>
            <span class="text-gray-light">@zoedsoupe.zeetech.io</span>
          </li>
          <li>
            <a href="mailto:zoey.spessanha@zeetech.io">zoey.spessanha@zeetech.io</a>
            <span class="text-gray-light">{gettext("for the good conversations")}</span>
          </li>
        </ul>
      </section>
    </main>
    """
  end

  defp zoey_code, do: @zoey_code

  attr :label, :string, required: true
  slot :inner_block, required: true

  defp into(assigns) do
    ~H"""
    <div>
      <p class="text-foreground font-medium">{@label}</p>
      <p class="text-gray-light">{render_slot(@inner_block)}</p>
    </div>
    """
  end

  attr :name, :string, required: true
  attr :href, :string, required: true
  slot :inner_block, required: true

  defp project(assigns) do
    ~H"""
    <li class="leading-relaxed">
      <a
        href={@href}
        target="_blank"
        rel="noopener"
        class="font-mono text-foreground hover:text-pink transition-colors"
      >
        {@name}
      </a>
      <span class="text-gray-light">{render_slot(@inner_block)}</span>
    </li>
    """
  end
end
