defmodule Punkte.User.Evaluate do
  @moduledoc """
  Evaluates the users' points executing a fragment calling the RANDOM function in the DB
  """

  import Ecto.Query
  require Logger
  alias Punkte.Repo

  def call do
    now = DateTime.utc_now()
    Logger.info("Evaluating users punctuation now(#{now})")

    Punkte.User
    |> update(set: [points: fragment("FLOOR(RANDOM() * 100 + 1)"), updated_at: ^now])
    |> Repo.update_all([])
  end
end
