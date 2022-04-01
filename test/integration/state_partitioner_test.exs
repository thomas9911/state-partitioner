defmodule StatePartitioner.Integration.StatePartitionerTest do
  use ExUnit.Case
  alias StatePartitioner.State
  alias StatePartitioner.State.Item

  test "schedule" do
    assert [] == State.keys()

    # "testing" should go to node 1
    node = NodeExt.list_all() |> Enum.find(&(&1 == :"node1@127.0.0.1"))

    StatePartitioner.schedule("testing", %{"data" => 1})
    StatePartitioner.schedule("testing", %{"data" => 2})
    StatePartitioner.schedule("testing", %{"data" => 3})

    assert ["testing"] =
             node
             |> StatePartitioner.call_node(State, :keys, [])
             |> Task.await()

    assert %Item{data: %{"data" => 3}, key: "testing"} =
             node
             |> StatePartitioner.call_node(State, :pop, ["testing"])
             |> Task.await()

    assert node
           |> StatePartitioner.call_node(State, :pop, ["testing"])
           |> Task.await()
           |> is_nil()
  end
end
