defmodule Punkte.User.ServerTest do
  use ExUnit.Case

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Punkte.Repo)

    pid = start_supervised!(Punkte.User.Server)

    Ecto.Adapters.SQL.Sandbox.allow(Punkte.Repo, self(), pid)

    {:ok, %{pid: pid}}
  end

  describe "fetch" do
    test "returns nil before evaluating the points", %{pid: pid} do
      {:ok, result} = GenServer.call(pid, :fetch)

      assert result == [nil, []]
    end

    test "the timestamp is between last execution and now", %{pid: pid} do
      last_execution = DateTime.utc_now()
      {:ok, result} = GenServer.call(pid, :fetch)
      after_last = DateTime.utc_now()

      {:ok, [timestamp, _]} = GenServer.call(pid, :fetch)


      assert DateTime.diff(timestamp, last_execution, :microsecond) > 0
      assert DateTime.diff(timestamp, after_last, :microsecond) < 0
    end
  end
end
