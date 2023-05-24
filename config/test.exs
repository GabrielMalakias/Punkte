import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :punkte, Punkte.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "punkte_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :punkte, PunkteWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "M37WcPfx6jpQcWUYAdSUrVrVbWKfT3evp5IeQgOoZlK3JvoEC0Zi7C+okrk7wE/w",
  server: false

config :punkte,
  points_interval: 50..60

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
