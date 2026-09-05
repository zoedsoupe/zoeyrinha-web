defmodule Zoeyrinha.MixProject do
  use Mix.Project

  def project do
    [
      app: :zoeyrinha,
      version: "0.1.0",
      elixir: "~> 1.20",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: [
        zoeyrinha: [
          strip_beams: true,
          validate_compile_env: true,
          quiet: true,
          include_erts: true,
          include_executables_for: [:unix]
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Zoeyrinha.Application, []},
      extra_applications: [:logger, :runtime_tools, :inets]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.14"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:lucide_icons, "~> 2.0.12"},
      {:phoenix_live_view, "~> 1.0"},
      {:gettext, "~> 1.0"},
      {:nimble_publisher, "~> 2.0"},
      {:mdex, "~> 0.13.5"},
      # syntax highlighting lexers for nimble_publisher code fences;
      {:makeup_elixir, "~> 1.0"},
      {:makeup_erlang, "~> 1.0"},
      {:makeup_syntect, "~> 0.1"},
      {:floki, ">= 0.30.0", only: :test},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
      {:bandit, "~> 1.5"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind zoeyrinha", "esbuild zoeyrinha"],
      "assets.deploy": [
        "tailwind zoeyrinha --minify",
        "esbuild zoeyrinha --minify",
        "phx.digest"
      ]
    ]
  end
end
