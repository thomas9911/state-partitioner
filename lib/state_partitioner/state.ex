defmodule StatePartitioner.State do
  @moduledoc """
  Module to keep the state, currently it is a gen server, maybe we should do something smarter in the future.
  """
  use GenServer

  alias StatePartitioner.State.Item

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def put(key, data) do
    GenServer.cast(__MODULE__, {:put, {key, data}})
  end

  def pop(key) do
    GenServer.call(__MODULE__, {:pop, key})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def keys do
    GenServer.call(__MODULE__, :keys)
  end

  def list do
    GenServer.call(__MODULE__, :list)
  end

  def list_expired do
    GenServer.call(__MODULE__, :list_expired)
  end

  def pop_expired do
    GenServer.call(__MODULE__, :pop_expired)
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:pop, key}, _from, state) do
    {item, state} = Map.pop(state, key)
    {:reply, item, state}
  end

  def handle_call({:get, key}, _from, state) do
    item = Map.get(state, key)
    {:reply, item, state}
  end

  def handle_call(:pop_expired, _from, state) do
    {expired_keys, expired_items} = blem_expired(state)

    state = Map.drop(state, expired_keys)

    {:reply, expired_items, state}
  end

  def handle_call(:list_expired, _from, state) do
    {_, expired_items} = blem_expired(state)

    {:reply, expired_items, state}
  end

  def handle_call(:keys, _from, state) do
    {:reply, Map.keys(state), state}
  end

  def handle_call(:list, _from, state) do
    {:reply, Map.values(state), state}
  end

  @impl true
  def handle_cast({:put, {key, data}}, state) do
    {:noreply, Map.put(state, key, Item.new(key, data))}
  end

  def blem_expired(state) do
    state
    |> Enum.flat_map(fn {key, item} ->
      if Item.expired?(item) do
        [{key, item}]
      else
        []
      end
    end)
    |> Enum.unzip()
  end
end
