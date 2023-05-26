defmodule Punkte.User.FetchTest do
  use ExUnit.Case, async: true

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Punkte.Repo)

    Enum.each(0..10, fn x ->
      Punkte.Repo.insert!(%Punkte.User{id: x, points: x})
    end)

    :ok
  end

  describe "call" do
    test "returns users with a higher score than the bottom limit" do
      users = Punkte.User.Fetch.call(3)

      Enum.each(users, fn user ->
        assert user.points > 3
      end)
    end

    test "returns only two users" do
      users = Punkte.User.Fetch.call(3)

      assert length(users) == 2
    end
  end
end
