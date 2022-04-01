defmodule StatePartitioner.StateTest do
  use ExUnit.Case

  alias StatePartitioner.State
  alias StatePartitioner.State.Item

  setup do
    start_supervised!(State)

    :ok
  end

  test "keys" do
    State.put("a", %{})
    State.put("b", %{})
    State.put("c", %{})
    assert ["a", "b", "c"] = State.keys()
    assert ["a", "b", "c"] = State.keys()
  end

  test "pop" do
    State.put("a", %{})
    State.put("b", %{"some" => "data"})
    State.put("c", %{})

    assert %Item{key: "a", data: %{}} = State.pop("a")
    assert nil == State.pop("a")
    assert %Item{key: "b", data: %{"some" => "data"}} = State.pop("b")
    assert nil == State.pop("b")

    assert ["c"] = State.keys()
  end

  test "get" do
    State.put("a", %{})
    State.put("b", %{"some" => "data"})
    State.put("c", %{})

    assert %Item{key: "a", data: %{}} = State.get("a")
    assert %Item{key: "a", data: %{}} = State.get("a")
    assert %Item{key: "b", data: %{"some" => "data"}} = State.get("b")
    assert %Item{key: "b", data: %{"some" => "data"}} = State.get("b")

    assert ["a", "b", "c"] = State.keys()
  end
end
