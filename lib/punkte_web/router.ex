defmodule PunkteWeb.Router do
  use PunkteWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PunkteWeb do
    pipe_through :api
  end
end
