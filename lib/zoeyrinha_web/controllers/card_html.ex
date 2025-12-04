defmodule ZoeyrinhaWeb.CardHTML do
  use ZoeyrinhaWeb, :html

  def show(assigns) do
    ~H"""
    <main class="min-h-screen flex items-center justify-center px-4 py-12">
      <div class="max-w-md w-full">
        <%!-- Digital Business Card --%>
        <div class="bg-cursorline border-2 border-pink/50 rounded-2xl p-8 shadow-2xl shadow-pink/20">
          <%!-- Profile Image --%>
          <div class="flex justify-center mb-6">
            <img
              src={~p"/images/profile.jpeg"}
              alt="Zoey de Souza Pessanha"
              class="w-32 h-32 rounded-full border-4 border-pink shadow-xl shadow-pink/30"
            />
          </div>

          <%!-- Name & Title --%>
          <div class="text-center mb-6">
            <h1 class="text-3xl font-bold text-gradient-pink mb-2">
              zoedsoupe
            </h1>
            <p class="text-lg text-lavender font-semibold mb-1">
              {gettext("Software Engineer | OSS Maintainer | Podcast Co-Host")}
            </p>
            <p class="text-sm text-gray-light">
              {gettext("Transforming coffee into functional code since 2017")}
            </p>
          </div>

          <%!-- Contact Links --%>
          <div class="space-y-3 mb-6">
            <a
              href="mailto:zoey.spessanha@zeetech.io"
              class="flex items-center gap-3 p-3 bg-background rounded-lg hover:bg-selection transition-colors group"
            >
              <Lucideicons.mail class="w-5 h-5 text-pink group-hover:text-pink-soft transition-colors" />
              <span class="text-foreground/90 group-hover:text-foreground">
                zoey.spessanha@zeetech.io
              </span>
            </a>

            <a
              href="https://linkedin.com/in/zoedsoupe"
              target="_blank"
              class="flex items-center gap-3 p-3 bg-background rounded-lg hover:bg-selection transition-colors group"
            >
              <Lucideicons.linkedin class="w-5 h-5 text-blue group-hover:text-blue/80 transition-colors" />
              <span class="text-foreground/90 group-hover:text-foreground">LinkedIn</span>
            </a>

            <a
              href="https://github.com/zoedsoupe"
              target="_blank"
              class="flex items-center gap-3 p-3 bg-background rounded-lg hover:bg-selection transition-colors group"
            >
              <Lucideicons.github class="w-5 h-5 text-lavender group-hover:text-lavender/80 transition-colors" />
              <span class="text-foreground/90 group-hover:text-foreground">GitHub</span>
            </a>

            <a
              href="https://dev.to/zoedsoupe"
              target="_blank"
              class="flex items-center gap-3 p-3 bg-background rounded-lg hover:bg-selection transition-colors group"
            >
              <Lucideicons.code class="w-5 h-5 text-green group-hover:text-green/80 transition-colors" />
              <span class="text-foreground/90 group-hover:text-foreground">Dev.to</span>
            </a>

            <a
              href="https://bsky.app/profile/zoedsoupe.zeetech.io"
              target="_blank"
              class="flex items-center gap-3 p-3 bg-background rounded-lg hover:bg-selection transition-colors group"
            >
              <Lucideicons.cloud class="w-5 h-5 text-peach group-hover:text-peach/80 transition-colors" />
              <span class="text-foreground/90 group-hover:text-foreground">BlueSky</span>
            </a>
          </div>

          <%!-- Tech Stack Badges --%>
          <div class="border-t border-selection pt-6">
            <p class="text-sm text-gray-light text-center mb-3">
              {gettext("Tech Stack")}
            </p>
            <div class="flex flex-wrap gap-2 justify-center">
              <.badge color="pink">Elixir</.badge>
              <.badge color="peach">Rust</.badge>
              <.badge color="blue">TypeScript</.badge>
              <.badge color="lavender">Zig</.badge>
            </div>
          </div>

          <%!-- Action Buttons --%>
          <div class="flex gap-3 mt-6">
            <.button href="/me" variant="primary" class="flex-1">
              {gettext("Full Profile")}
            </.button>
            <.button href="/" variant="outline" class="flex-1">
              {gettext("Home")}
            </.button>
          </div>
        </div>

        <%!-- Footer Note --%>
        <p class="text-center text-gray text-sm mt-6">
          &copy; {DateTime.utc_now().year} ZEETECH
        </p>
      </div>
    </main>
    """
  end
end
