defmodule PunkteWeb.UsersController do
  use PunkteWeb, :controller

  def index(conn, _) do
    json(conn, serialize())
  end

  def serialize() do
    [%{users: [%{id: 1, points: 10}], timestamp: "2020-07-30 17:09:33"}]
  end
end
