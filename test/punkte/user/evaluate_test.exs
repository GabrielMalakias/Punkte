defmodule Punkte.User.EvaluateTest do
  use ExUnit.Case, async: true
  import Ecto.Query, only: [from: 2]

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Punkte.Repo)

    Punkte.Repo.insert!(%Punkte.User{points: 0})

    :ok
  end

  describe "call" do
    test "updates the user setting assigning a random number of points" do
      user = Punkte.Repo.one!(from u in Punkte.User, limit: 1)
      assert user.points == 0

      Punkte.User.Evaluate.call()

      user = Punkte.Repo.get_by!(Punkte.User, id: user.id)
      assert user.points != 0
    end
  end
end
