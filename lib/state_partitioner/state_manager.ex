defmodule StatePartitioner.StateManager do
  @moduledoc """
  Module that calls the current node or forwards to a remote node to check/fetch/put the data
  """

  alias StatePartitioner.State

  def put(key, data) do
    call(State, :put, [key, data])
  end

  def pop(_) do
    raise "not implemented"
  end

  def get(key) do
    call(State, :get, [key])
  end

  def keys do
    do_list(State, :keys, [], NodeExt.list_all())
  end

  def list do
    do_list(State, :list, [], NodeExt.list_all())
  end

  def list_expired do
    do_list(State, :list_expired, [], NodeExt.list_all())
  end

  def pop_expired do
    raise "not implemented"
  end

  def call(module, function, [key | _] = args) do
    key
    |> StatePartitioner.Partitioner.for_node()
    |> do_call(module, function, args)
  end

  defp do_list(module, function, args, nodes_list) do
    nodes_list
    |> Enum.flat_map(&do_call({:other, &1}, module, function, args))
  end

  defp do_call({:other, node}, module, function, args) do
    node |> StatePartitioner.call_node(module, function, args) |> Task.await()
  end

  defp do_call(:me, module, function, args) do
    apply(module, function, args)
  end
end
