defmodule PunkteWeb.Router do
  use PunkteWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PunkteWeb do
    pipe_through :api

    get "/", UsersController, :index
  end
end
