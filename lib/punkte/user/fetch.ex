defmodule Punkte.User.Fetch do
  @moduledoc """
  Fetches and returns all the users which have a higher number of points than the bottom_limit
  """

  import Ecto.Query, only: [from: 2]

  alias Punkte.Repo

  @limit 2

  def call(bottom_limit) do
    bottom_limit
    |> query
    |> Repo.all()
  end

  defp query(points) do
    from(u in Punkte.User,
      select: %{id: u.id, points: u.points},
      where: u.points > ^points,
      limit: ^@limit
    )
  end
end
