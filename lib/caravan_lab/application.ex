defmodule CaravanLab.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies)

    children = [
      CaravanLabWeb.Telemetry,
      {Cluster.Supervisor, [topologies, [name: Cluster.ClusterSupervisor]]},
      {Phoenix.PubSub, name: CaravanLab.PubSub},
      # Start a worker by calling: CaravanLab.Worker.start_link(arg)
      # {CaravanLab.Worker, arg},
      # Start to serve requests, typically the last entry
      CaravanLabWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CaravanLab.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CaravanLabWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
