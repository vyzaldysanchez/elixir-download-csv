defmodule App do
  use Application
  require Logger

  alias Plug.Adapters.Cowboy

  def start(_type, _args) do
    children = [
      Cowboy.child_spec(:http, App.Router.AppRouter, [], [port: 4000])
    ]

    Logger.info("Started application")
    App.Repo.start_link()
    Supervisor.start_link(children, [strategy: :one_for_one])
  end
end
