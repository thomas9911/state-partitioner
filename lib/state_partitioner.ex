defmodule StatePartitioner do
  @moduledoc """
  Documentation for `StatePartitioner`.
  """

  def schedule(identfier, data) do
    identfier
    |> StatePartitioner.Partitioner.for_node()
    |> schedule_on_node(identfier, data)
  end

  def schedule_on_node(:me, identfier, data) do
    StatePartitioner.State.put(identfier, data)
  end

  def schedule_on_node({:other, node}, identfier, data) do
    node
    |> call_node(__MODULE__, :schedule, [identfier, data])
    |> Task.await()
  end

  def call_node(node, module, func, args) do
    supervisor = {StatePartitioner.DistSupervisor, node}
    Task.Supervisor.async(supervisor, module, func, args)
  end
end
