defmodule ZoeyrinhaWeb.MeHTML do
  use ZoeyrinhaWeb, :html

  def show(assigns) do
    ~H"""
    <main class="min-h-screen pb-16">
      <%!-- Profile Header --%>
      <section class="px-4 sm:px-6 lg:px-8 py-12 bg-cursorline border-b border-selection">
        <div class="max-w-5xl mx-auto">
          <div class="flex flex-col md:flex-row gap-8 items-center md:items-start">
            <div class="flex-shrink-0">
              <img
                src={~p"/images/profile.jpeg"}
                alt="Zoey de Souza Pessanha"
                class="w-40 h-40 rounded-full border-4 border-pink shadow-2xl shadow-pink/30"
              />
            </div>
            <div class="flex-1 text-center md:text-left">
              <h1 class="text-4xl md:text-5xl font-bold text-gradient-pink mb-2">
                Zoey de Souza Pessanha
              </h1>
              <p class="text-xl md:text-2xl text-lavender font-semibold mb-3">
                {gettext("Senior Software Engineer | OSS Maintainer | Elixir em Foco Co-Host")}
              </p>
              <p class="text-gray-light mb-4">
                <span class="text-pink font-semibold">{gettext("Location:")}</span>
                {gettext("Campos dos Goytacazes, Rio de Janeiro, Brazil")}
              </p>
              <.social_links class="justify-center md:justify-start" />
            </div>
          </div>
        </div>
      </section>

      <%!-- Summary --%>
      <section class="px-4 sm:px-6 lg:px-8 py-16">
        <div class="max-w-5xl mx-auto">
          <h2 class="text-4xl font-bold text-gradient-pink mb-6 text-center">
            {gettext("Summary")}
          </h2>
          <div class="bg-cursorline border border-selection rounded-2xl p-8">
            <p class="text-lg text-foreground/90 leading-relaxed">
              {gettext(
                "Senior Software Engineer specializing in high-scale financial systems and distributed architectures using functional programming. Extensive experience with Brazilian payment methods (credit cards, PIX) and building resilient, fault-tolerant fintech platforms. Active open-source maintainer in the Elixir ecosystem, contributing developer tools and protocol implementations. Co-host of Brazil's first Elixir podcast, advocating for functional programming and community knowledge sharing."
              )}
            </p>
          </div>
        </div>
      </section>

      <%!-- Open Source Projects - HERO SECTION --%>
      <section class="px-4 sm:px-6 lg:px-8 py-16 bg-cursorline">
        <div class="max-w-7xl mx-auto">
          <h2 class="text-5xl font-bold text-center text-gradient-pink mb-4">
            {gettext("Open Source Contributions")}
          </h2>
          <p class="text-center text-lg text-gray-light mb-12 max-w-3xl mx-auto">
            {gettext(
              "Building tools and libraries to empower the Elixir ecosystem and functional programming community"
            )}
          </p>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
            <%!-- anubis-mcp --%>
            <.card
              title="anubis-mcp"
              subtitle={gettext("44 stars · 195 commits")}
              link="https://github.com/zoedsoupe/anubis-mcp"
              class="border-2 border-pink/50 shadow-2xl shadow-pink/20"
            >
              <p class="mb-4">
                {gettext(
                  "High-performance Model Context Protocol SDK in Elixir. Actively maintained fork of hermes-mcp after CloudWalk discontinued maintenance. Comprehensive client/server implementations with multiple transport mechanisms (HTTP, SSE, WebSocket) and OTP-based architecture."
                )}
              </p>
              <div class="flex flex-wrap gap-2">
                <.badge color="pink">Elixir</.badge>
                <.badge color="blue">MCP</.badge>
                <.badge color="green">OTP</.badge>
                <.badge color="lavender">{gettext("Active Maintenance")}</.badge>
              </div>
            </.card>

            <%!-- supabase-ex --%>
            <.card
              title="supabase-ex"
              subtitle={gettext("Complete Supabase SDK")}
              link="https://github.com/zoedsoupe/supabase-ex"
              class="border-2 border-blue/50 shadow-2xl shadow-blue/20"
            >
              <p class="mb-4">
                {gettext(
                  "Complete Supabase SDK for Elixir including storage-ex (Storage client), gotrue-ex (authentication), and postgrest-ex (database client). Enables full Supabase integration in Elixir applications with type-safe interfaces."
                )}
              </p>
              <div class="flex flex-wrap gap-2">
                <.badge color="pink">Elixir</.badge>
                <.badge color="lavender">Supabase</.badge>
                <.badge color="green">{gettext("Type-Safe")}</.badge>
              </div>
            </.card>

            <%!-- peri --%>
            <.card
              title="peri"
              subtitle={gettext("Composable Validation Library")}
              link="https://github.com/zoedsoupe/peri"
            >
              <p class="mb-4">
                {gettext(
                  "Composable validation library for Elixir with schema-based validation, type safety, and comprehensive error handling. Used across multiple production applications."
                )}
              </p>
              <div class="flex flex-wrap gap-2">
                <.badge color="pink">Elixir</.badge>
                <.badge color="peach">Validation</.badge>
                <.badge color="blue">{gettext("Production Ready")}</.badge>
              </div>
            </.card>

            <%!-- exlings --%>
            <.card
              title="exlings"
              subtitle={gettext("Interactive Learning Tool")}
              link="https://github.com/zoedsoupe/exlings"
            >
              <p class="mb-4">
                {gettext(
                  "Interactive learning tool for Elixir inspired by rustlings. Self-contained exercises teaching Elixir through practice, helping beginners learn the language."
                )}
              </p>
              <div class="flex flex-wrap gap-2">
                <.badge color="pink">Elixir</.badge>
                <.badge color="green">Education</.badge>
                <.badge color="lavender">{gettext("Beginner Friendly")}</.badge>
              </div>
            </.card>
          </div>

          <div class="text-center">
            <p class="text-gray-light mb-4">
              {gettext(
                "Additional projects include proto_rune (AT Protocol/Bluesky SDK), nexus (CLI builder), lucide_icons, and various other Elixir developer tools."
              )}
            </p>
            <.button href="https://github.com/zoedsoupe" variant="primary">
              {gettext("View Full Portfolio on GitHub")}
            </.button>
          </div>
        </div>
      </section>

      <%!-- Technical Skills --%>
      <section class="px-4 sm:px-6 lg:px-8 py-16">
        <div class="max-w-5xl mx-auto">
          <h2 class="text-4xl font-bold text-gradient-blue mb-8 text-center">
            {gettext("Technical Skills")}
          </h2>

          <div class="space-y-6">
            <div class="bg-cursorline border border-selection rounded-xl p-6">
              <h3 class="text-xl font-bold text-pink mb-4">{gettext("Primary Languages")}</h3>
              <div class="flex flex-wrap gap-2">
                <.badge color="pink">Elixir</.badge>
                <.badge color="peach">Rust</.badge>
                <.badge color="lavender">Zig</.badge>
                <.badge color="blue">TypeScript</.badge>
              </div>
            </div>

            <div class="bg-cursorline border border-selection rounded-xl p-6">
              <h3 class="text-xl font-bold text-pink mb-4">{gettext("Specializations")}</h3>
              <div class="flex flex-wrap gap-2">
                <.badge color="green">{gettext("High-Scale Financial Systems")}</.badge>
                <.badge color="blue">{gettext("Brazilian Payment Methods")}</.badge>
                <.badge color="lavender">{gettext("Distributed Systems")}</.badge>
                <.badge color="peach">{gettext("MCP Architecture")}</.badge>
              </div>
            </div>

            <div class="bg-cursorline border border-selection rounded-xl p-6">
              <h3 class="text-xl font-bold text-pink mb-4">{gettext("Focus Areas")}</h3>
              <div class="flex flex-wrap gap-2">
                <.badge color="pink">{gettext("Functional Programming")}</.badge>
                <.badge color="green">{gettext("Fault-Tolerant Architectures")}</.badge>
                <.badge color="blue">{gettext("Category Theory")}</.badge>
                <.badge color="lavender">{gettext("Protocol Design")}</.badge>
              </div>
            </div>
          </div>
        </div>
      </section>

      <%!-- Community Engagement --%>
      <section class="px-4 sm:px-6 lg:px-8 py-16 bg-cursorline">
        <div class="max-w-5xl mx-auto">
          <h2 class="text-4xl font-bold text-gradient-pink mb-8 text-center">
            {gettext("Community Engagement")}
          </h2>

          <.card title={gettext("Co-Host | Elixir em Foco")} link="https://elixiremfoco.com">
            <p class="mb-4">
              {gettext(
                "Brazil's first podcast dedicated to the Elixir community. Explores Elixir applications across web development, embedded systems, machine learning, and more. Features discussions with professionals from complementary ecosystems (Erlang, Gleam, Clojure). Supported by the Erlang Ecosystem Foundation."
              )}
            </p>
            <div class="flex flex-wrap gap-2">
              <.badge color="pink">Elixir</.badge>
              <.badge color="blue">Podcast</.badge>
              <.badge color="green">{gettext("EEF Supported")}</.badge>
              <.badge color="lavender">{gettext("Community")}</.badge>
            </div>
          </.card>
        </div>
      </section>

      <%!-- Professional Experience Note --%>
      <section class="px-4 sm:px-6 lg:px-8 py-12">
        <div class="max-w-5xl mx-auto">
          <div class="bg-blue/20 border border-blue/30 rounded-xl p-6 text-center">
            <h3 class="text-2xl font-bold text-blue mb-3">
              {gettext("Professional Experience")}
            </h3>
            <p class="text-foreground/90 mb-4">
              {gettext(
                "For detailed professional experience including roles at Dashbit, CloudWalk, Cumbuca, Nubank, and more, please visit my LinkedIn profile."
              )}
            </p>
            <.button href="https://www.linkedin.com/in/zoedsoupe" variant="secondary">
              {gettext("View LinkedIn Profile")}
            </.button>
          </div>
        </div>
      </section>

      <%!-- Education --%>
      <section class="px-4 sm:px-6 lg:px-8 py-16">
        <div class="max-w-5xl mx-auto">
          <h2 class="text-4xl font-bold text-gradient-pink mb-8 text-center">
            {gettext("Education")}
          </h2>

          <div class="space-y-6">
            <.card
              title={gettext("Bachelor of Applied Science - Computer Science")}
              subtitle={gettext("Descomplica Faculdade Digital | April 2024 - October 2026")}
            >
              <p class="text-gray-light">{gettext("Currently pursuing")}</p>
            </.card>

            <.card
              title={gettext("Bachelor's Degree - Computer Science")}
              subtitle={
                gettext("UENF - Universidade Estadual do Norte Fluminense | March 2019 - June 2022")
              }
            >
              <p class="text-gray-light">{gettext("Completed")}</p>
            </.card>

            <.card
              title={gettext("Technical Degree - Information Technology")}
              subtitle={
                gettext(
                  "Instituto Federal de Educação, Ciência e Tecnologia Fluminense | March 2018 - March 2020"
                )
              }
            >
              <p class="text-gray-light">{gettext("Completed")}</p>
            </.card>
          </div>
        </div>
      </section>

      <%!-- Languages & Certifications --%>
      <section class="px-4 sm:px-6 lg:px-8 py-16 bg-cursorline">
        <div class="max-w-5xl mx-auto">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <%!-- Languages --%>
            <div>
              <h2 class="text-3xl font-bold text-gradient-blue mb-6 text-center">
                {gettext("Languages")}
              </h2>
              <div class="bg-background border border-selection rounded-xl p-6">
                <div class="space-y-4">
                  <div>
                    <h3 class="text-xl font-bold text-pink mb-2">{gettext("Portuguese")}</h3>
                    <.badge color="green">{gettext("Native")}</.badge>
                  </div>
                  <div>
                    <h3 class="text-xl font-bold text-pink mb-2">{gettext("English")}</h3>
                    <.badge color="blue">{gettext("Full Professional Proficiency")}</.badge>
                  </div>
                </div>
              </div>
            </div>

            <%!-- Certifications --%>
            <div>
              <h2 class="text-3xl font-bold text-gradient-blue mb-6 text-center">
                {gettext("Certifications")}
              </h2>
              <div class="bg-background border border-selection rounded-xl p-6">
                <ul class="space-y-3">
                  <li class="flex items-start gap-2">
                    <span class="text-pink mt-1">●</span>
                    <span class="text-foreground/90">
                      {gettext("CS50x Certificate (Harvard's Introduction to Computer Science)")}
                    </span>
                  </li>
                  <li class="flex items-start gap-2">
                    <span class="text-pink mt-1">●</span>
                    <span class="text-foreground/90">
                      {gettext("JavaScript (Basic) - HackerRank")}
                    </span>
                  </li>
                  <li class="flex items-start gap-2">
                    <span class="text-pink mt-1">●</span>
                    <span class="text-foreground/90">{gettext("FRONTIN Elas Programam 2023")}</span>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </section>

      <%!-- Contact --%>
      <section class="px-4 sm:px-6 lg:px-8 py-16">
        <div class="max-w-5xl mx-auto text-center">
          <h2 class="text-4xl font-bold text-gradient-pink mb-6">
            {gettext("Let's Connect")}
          </h2>
          <p class="text-lg text-gray-light mb-8">
            {gettext("I'm always open to interesting conversations and collaboration opportunities")}
          </p>
          <.social_links class="justify-center mb-6" />
          <div class="mt-4">
            <a
              href="mailto:zoey.spessanha@zeetech.io"
              class="text-blue hover:text-blue/80 text-lg font-medium"
            >
              zoey.spessanha@zeetech.io
            </a>
          </div>
        </div>
      </section>
    </main>
    """
  end
end
