defmodule SpartanKick.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    port = Application.fetch_env!(:spartan_kick, :port)

    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: SpartanKickWeb.Router,
        options: [port: port]
      )
      # Starts a worker by calling: SpartanKick.Worker.start_link(arg)
      # {SpartanKick.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SpartanKick.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
