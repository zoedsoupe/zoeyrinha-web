defmodule ZoeyrinhaWeb.LandingHTML do
  use ZoeyrinhaWeb, :html

  def show(assigns) do
    ~H"""
    <main class="min-h-screen">
      <%!-- Hero Section --%>
      <section class="relative px-4 sm:px-6 lg:px-8 py-20 sm:py-32">
        <div class="max-w-7xl mx-auto text-center">
          <h1 class="text-5xl sm:text-6xl md:text-7xl font-bold mb-6">
            <span class="text-gradient-pink">Zoeyrinha</span>
          </h1>
          <p class="text-xl sm:text-2xl md:text-3xl text-lavender font-semibold mb-4">
            {gettext("Software Engineer | OSS Maintainer | Podcast Co-Host")}
          </p>
          <p class="text-lg sm:text-xl text-gray-light max-w-3xl mx-auto mb-10">
            {gettext("Transforming coffee into functional code, one pattern match at a time")}
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
            <.button href="/me" variant="primary">
              {gettext("About Me")}
            </.button>
            <.button href="https://github.com/zoedsoupe" variant="secondary">
              {gettext("View Projects")}
            </.button>
          </div>
        </div>
      </section>

      <%!-- QuickBio Section --%>
      <section class="px-4 sm:px-6 lg:px-8 py-16">
        <div class="max-w-5xl mx-auto">
          <div class="bg-cursorline border border-selection rounded-2xl p-8 md:p-12">
            <div class="flex flex-col md:flex-row gap-8 items-center md:items-start">
              <div class="flex-shrink-0">
                <img
                  src={~p"/images/profile.jpeg"}
                  alt="Zoey de Souza Pessanha"
                  class="w-48 h-48 rounded-full border-4 border-pink shadow-2xl shadow-pink/30"
                />
              </div>
              <div class="flex-1 text-center md:text-left">
                <h2 class="text-3xl font-bold text-pink mb-4">
                  {gettext("Hi, I'm Zoey!")}
                </h2>
                <p class="text-lg text-foreground/90 mb-4">
                  {gettext(
                    "Senior Software Engineer specializing in functional programming, high-scale financial systems, and distributed architectures. Active open-source contributor with a passion for Elixir, Rust, and building robust, fault-tolerant systems."
                  )}
                </p>
                <div class="flex flex-wrap gap-2 justify-center md:justify-start mb-6">
                  <.badge color="pink">Elixir</.badge>
                  <.badge color="peach">Rust</.badge>
                  <.badge color="blue">TypeScript</.badge>
                  <.badge color="lavender">Zig</.badge>
                  <.badge color="green">{gettext("5+ years experience")}</.badge>
                </div>
                <p class="text-gray-light">
                  <span class="text-pink font-semibold">
                    {gettext("Location:")}
                  </span>
                  {gettext("Campos dos Goytacazes, RJ, Brazil")}
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <%!-- Featured Projects Section --%>
      <section class="px-4 sm:px-6 lg:px-8 py-16">
        <div class="max-w-7xl mx-auto">
          <h2 class="text-4xl font-bold text-center text-gradient-pink mb-12">
            {gettext("Featured Open Source Projects")}
          </h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <.card
              title="anubis-mcp"
              subtitle={gettext("44 stars · 195 commits")}
              link="https://github.com/zoedsoupe/anubis-mcp"
            >
              <p class="mb-4">
                {gettext(
                  "High-performance Model Context Protocol SDK in Elixir. Fork of hermes-mcp with comprehensive client/server implementations for building AI-powered applications."
                )}
              </p>
              <div class="flex flex-wrap gap-2">
                <.badge color="pink">Elixir</.badge>
                <.badge color="blue">MCP</.badge>
                <.badge color="green">SDK</.badge>
              </div>
            </.card>

            <.card
              title="supabase-ex"
              subtitle={gettext("Complete Supabase SDK")}
              link="https://github.com/zoedsoupe/supabase-ex"
            >
              <p class="mb-4">
                {gettext(
                  "Full Supabase integration for Elixir including storage-ex, gotrue-ex, and postgrest-ex. Comprehensive toolkit for building applications with Supabase backend."
                )}
              </p>
              <div class="flex flex-wrap gap-2">
                <.badge color="pink">Elixir</.badge>
                <.badge color="lavender">Supabase</.badge>
                <.badge color="green">Full SDK</.badge>
              </div>
            </.card>

            <.card
              title="peri"
              subtitle={gettext("Composable Validation")}
              link="https://github.com/zoedsoupe/peri"
            >
              <p class="mb-4">
                {gettext(
                  "Composable validation library with schema-based validation, type safety, and comprehensive error handling. Built for production Elixir applications."
                )}
              </p>
              <div class="flex flex-wrap gap-2">
                <.badge color="pink">Elixir</.badge>
                <.badge color="peach">Validation</.badge>
                <.badge color="blue">Type Safety</.badge>
              </div>
            </.card>

            <.card
              title="exlings"
              subtitle={gettext("Interactive Learning")}
              link="https://github.com/zoedsoupe/exlings"
            >
              <p class="mb-4">
                {gettext(
                  "Interactive Elixir learning tool inspired by rustlings. Hands-on exercises to master Elixir concepts through practice and immediate feedback."
                )}
              </p>
              <div class="flex flex-wrap gap-2">
                <.badge color="pink">Elixir</.badge>
                <.badge color="green">Education</.badge>
                <.badge color="lavender">Interactive</.badge>
              </div>
            </.card>
          </div>

          <div class="text-center mt-10">
            <.button href="https://github.com/zoedsoupe" variant="outline">
              {gettext("View all projects on GitHub")}
            </.button>
          </div>
        </div>
      </section>

      <%!-- Community Section --%>
      <section class="px-4 sm:px-6 lg:px-8 py-16">
        <div class="max-w-5xl mx-auto">
          <div class="bg-cursorline border border-selection rounded-2xl p-8 md:p-12">
            <div class="text-center">
              <h2 class="text-4xl font-bold text-gradient-blue mb-6">
                {gettext("Community Engagement")}
              </h2>
              <h3 class="text-2xl font-bold text-pink mb-4">
                {gettext("Elixir em Foco Podcast")}
              </h3>
              <p class="text-lg text-foreground/90 max-w-3xl mx-auto mb-6">
                {gettext(
                  "Co-host of Brazil's first Elixir podcast, exploring web development, embedded systems, machine learning, and conversations with the Erlang, Gleam, and Clojure ecosystems. Supported by the Erlang Ecosystem Foundation."
                )}
              </p>
              <div class="flex flex-wrap gap-3 justify-center mb-8">
                <.badge color="pink">Elixir</.badge>
                <.badge color="blue">Erlang</.badge>
                <.badge color="lavender">Gleam</.badge>
                <.badge color="peach">Podcast</.badge>
                <.badge color="green">{gettext("EEF Supported")}</.badge>
              </div>
              <.button href="https://elixiremfoco.com" variant="secondary">
                {gettext("Listen to the Podcast")}
              </.button>
            </div>
          </div>
        </div>
      </section>

      <%!-- Contact Section --%>
      <section class="px-4 sm:px-6 lg:px-8 py-16">
        <div class="max-w-5xl mx-auto text-center">
          <h2 class="text-4xl font-bold text-gradient-pink mb-6">
            {gettext("Let's Connect")}
          </h2>
          <p class="text-lg text-gray-light mb-8">
            {gettext("Find me on social media or send me an email")}
          </p>
          <.social_links class="justify-center" />
        </div>
      </section>
    </main>
    """
  end
end
