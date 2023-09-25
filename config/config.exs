# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :battleship,
  ecto_repos: [Battleship.Repo]

# Configures the endpoint
config :battleship, BattleshipWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Jyd4Rpqlg8FOSEh+FTaDLalrWBStz/HH4BrYqo9FhY5VG1WilE2zYuDE9bH7Aqw+",
  render_errors: [view: BattleshipWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Battleship.PubSub,
  live_view: [signing_salt: "hwQbF9AT"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
