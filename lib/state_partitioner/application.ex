defmodule StatePartitioner.Application do
  # # See https://hexdocs.pm/elixir/Application.html
  # # for more information on OTP Applications
  # @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = [
      example: [
        # for course replace this with the kubernetes one
        strategy: Cluster.Strategy.LocalEpmd
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: StatePartitioner.ClusterSupervisor]]},
      {Task.Supervisor, [name: StatePartitioner.DistSupervisor]}
    ]

    children =
      if state_started?() do
        [{StatePartitioner.State, []} | children]
      else
        children
      end

    Supervisor.start_link(children, strategy: :one_for_one, name: StatePartitioner.Supervisor)
  end

  defp state_started? do
    Application.get_env(:state_partitioner, :state_started, true)
  end
end
