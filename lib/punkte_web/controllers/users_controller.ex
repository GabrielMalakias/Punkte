defmodule PunkteWeb.UsersController do
  use PunkteWeb, :controller

  def index(conn, _) do
    json(conn, serialize(Punkte.User.Server.fetch))
  end

  defp serialize({:ok, [timestamp, users]}) do
    %{users: users, timestamp: timestamp}
  end

  defp serialize({_, _}) do
    %{users: [], timestamp: nil, error_msg: "Failed to fetch users"}
  end
end
