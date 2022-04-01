defmodule StatePartitioner.Integration.StateManagerTest do
  use ExUnit.Case
  alias StatePartitioner.State
  alias StatePartitioner.State.Item
  alias StatePartitioner.StateManager

  test "Just looks like a map / object" do
    StatePartitioner.schedule("test", %{})
    StatePartitioner.schedule("testing", %{})
    StatePartitioner.schedule("more testing", %{})
    StatePartitioner.schedule("also some testing", %{})

    assert ["also some testing", "more testing", "test", "testing"] = StateManager.keys() |> Enum.sort()
  end
end
