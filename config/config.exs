# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :zoeyrinha,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :zoeyrinha, ZoeyrinhaWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ZoeyrinhaWeb.ErrorHTML, json: ZoeyrinhaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Zoeyrinha.PubSub,
  live_view: [signing_salt: "2meZqbcU"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  zoeyrinha: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "4.1.10",
  zoeyrinha: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure Gettext for internationalization
config :zoeyrinha, ZoeyrinhaWeb.Gettext,
  default_locale: "en",
  locales: ~w(en pt_BR)

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
