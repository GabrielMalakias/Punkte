defmodule Punkte.User.ServerTest do
  use ExUnit.Case

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Punkte.Repo)

    pid = start_supervised!(Punkte.User.Server)

    Ecto.Adapters.SQL.Sandbox.allow(Punkte.Repo, self(), pid)

    {:ok, %{pid: pid}}
  end

  describe "Server.fetch/0" do
    test "returns nil before evaluating the points", %{pid: pid} do
      {:ok, result} = GenServer.call(pid, :fetch)

      assert result == [nil, []]
    end

    test "the timestamp is between last execution and now", %{pid: pid} do
      last_execution = DateTime.utc_now()
      {:ok, _} = GenServer.call(pid, :fetch)
      after_last = DateTime.utc_now()

      {:ok, [timestamp, _]} = GenServer.call(pid, :fetch)


      assert DateTime.diff(timestamp, last_execution, :microsecond) > 0
      assert DateTime.diff(timestamp, after_last, :microsecond) < 0
    end

    test "when the max number is bigger than ones in the db", %{pid: pid} do
      # Random number is between 50..60 in tests
      Enum.each(0..3, fn x ->
        Punkte.Repo.insert!(%Punkte.User{id: x, points: 0})
      end)

      Process.send_after(pid, :evaluate, 0)

      {:ok, [_, users]} = GenServer.call(pid, :fetch)

      assert users == []
    end

    test "when the max number is smaller than ones in the db", %{pid: pid} do
      # Random number is between 50..60 in tests
      Enum.each(0..3, fn x ->
        Punkte.Repo.insert!(%Punkte.User{id: x, points: 80})
      end)

      Process.send_after(pid, :evaluate, 0)

      {:ok, [_, users]} = GenServer.call(pid, :fetch)

      assert users == [%{id: 0, points: 80}, %{id: 1, points: 80}]
    end
  end
end
