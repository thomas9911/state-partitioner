defmodule StatePartitioner.Integration.NodeExtTest do
  use ExUnit.Case

  test "list all" do
    # the spawned nodes plus the current node
    assert 3 + 1 == length(NodeExt.list_all())
  end

  test "hash ordered list with hash" do
    assert [
             {:crypto.hash(:sha256, "node2@127.0.0.1"), "node2@127.0.0.1"},
             {:crypto.hash(:sha256, "node1@127.0.0.1"), "node1@127.0.0.1"},
             {:crypto.hash(:sha256, "node3@127.0.0.1"), "node3@127.0.0.1"}
           ] == NodeExt.hash_ordered_list_with_hash()
  end

  describe "hash ordered list, orderes on sha256 and not alphabetically" do
    test "just nodes" do
      assert ["node2@127.0.0.1", "node1@127.0.0.1", "node3@127.0.0.1"] ==
               NodeExt.hash_ordered_list()
    end

    test "alphabet" do
      alphabet = Enum.map(?a..?z, &<<&1>>)

      assert [
               "s",
               "u",
               "p",
               "j",
               "d",
               "n",
               "f",
               "x",
               "c",
               "b",
               "e",
               "r",
               "v",
               "w",
               "z",
               "m",
               "o",
               "k",
               "q",
               "y",
               "h",
               "l",
               "a",
               "g",
               "i",
               "t"
             ] == NodeExt.hash_ordered_list(alphabet, "")
    end
  end

  describe "self index" do
    test "found" do
      assert 0 == NodeExt.self_index(NodeExt.list_all(), "")
    end

    test "found, in more nodes" do
      alphabet = Enum.map(?a..?z, &<<&1>>)
      nodes = Enum.map(alphabet, &("node" <> &1)) ++ [Node.self()]

      assert 2 == NodeExt.self_index(nodes, "")
    end

    test "not found" do
      assert is_nil(NodeExt.self_index(NodeExt.list_all(), "random prefix"))
    end
  end
end
