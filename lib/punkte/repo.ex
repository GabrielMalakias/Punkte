defmodule Punkte.Repo do
  use Ecto.Repo,
    otp_app: :punkte,
    adapter: Ecto.Adapters.Postgres
end
