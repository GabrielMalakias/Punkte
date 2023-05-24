# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Punkte.Repo.insert!(%Punkte.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#

unless Punkte.Repo.exists?("users") do
  Punkte.Repo.query!("""
  INSERT INTO users (points, inserted_at, updated_at)
  SELECT 0, LOCALTIMESTAMP, LOCALTIMESTAMP FROM generate_series(1, 1000000)
  """)
end

