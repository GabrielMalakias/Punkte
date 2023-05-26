defmodule PunkteWeb.UsersControllerTest do
  use PunkteWeb.ConnCase, async: true

  setup do
    pid = start_supervised!(Punkte.User.Server)

    Ecto.Adapters.SQL.Sandbox.allow(Punkte.Repo, self(), pid)

    {:ok, %{pid: pid}}
  end

  describe "GET /" do
    test "it returns 200 with users and timestamp", %{conn: conn} do
      body = json_response(get(conn, ~p"/"), 200)

      assert %{"users" => _users, "timestamp" => _} = body
    end

    test "it updates the user points after the interval", %{conn: conn} do
      Enum.each(0..40, fn x ->
        Punkte.Repo.insert!(%Punkte.User{id: x, points: 0})
      end)

      body = json_response(get(conn, ~p"/"), 200)

      assert %{"users" => [], "timestamp" => _} = body

      # Waits until next iteration
      :timer.sleep(600)
       %{"users" => users, "timestamp" => _} = json_response(get(conn, ~p"/"), 200)

      assert Enum.count(users) == 2
    end
  end
end
