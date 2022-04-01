defmodule StatePartitioner.Integration.PartitionerTest do
  use ExUnit.Case

  describe "for node with actual nodes" do
    # the test runner is not called node<integer>
    # so here we will never call ourselves
    test "with text" do
      assert {:other, :"node1@127.0.0.1"} == StatePartitioner.Partitioner.for_node("testing")

      assert {:other, :"node2@127.0.0.1"} ==
               StatePartitioner.Partitioner.for_node("another testing")

      assert {:other, :"node2@127.0.0.1"} ==
               StatePartitioner.Partitioner.for_node("let me do some testing")

      assert {:other, :"node3@127.0.0.1"} ==
               StatePartitioner.Partitioner.for_node("let meeeee do more testing!!")
    end

    test "with uuid" do
      assert {:other, :"node1@127.0.0.1"} ==
               StatePartitioner.Partitioner.for_node("e16ea868178443e4875942b6ea9f4710")

      assert {:other, :"node1@127.0.0.1"} ==
               StatePartitioner.Partitioner.for_node("d95b3329b5764b1789027adba34bad77")

      assert {:other, :"node1@127.0.0.1"} ==
               StatePartitioner.Partitioner.for_node("e8e27f78921b493c984fdf6ebcf47d55")

      assert {:other, :"node2@127.0.0.1"} ==
               StatePartitioner.Partitioner.for_node("e4fc6c12e55e45aba5c5d9d7c1e59c38")

      assert {:other, :"node2@127.0.0.1"} ==
               StatePartitioner.Partitioner.for_node("af0e8c67928540d096518e0671757ebd")

      assert {:other, :"node2@127.0.0.1"} ==
               StatePartitioner.Partitioner.for_node("b8e8c3b2b8604d0e88e73798528074e3")

      assert {:other, :"node2@127.0.0.1"} ==
               StatePartitioner.Partitioner.for_node("bc69a8c74ccd4f219d383c31cdacbece")

      assert {:other, :"node2@127.0.0.1"} ==
               StatePartitioner.Partitioner.for_node("beaee5d1e5f3434ba87203e12af9ea28")

      assert {:other, :"node3@127.0.0.1"} ==
               StatePartitioner.Partitioner.for_node("763ec945ece445c189c2b31ae65fda84")

      assert {:other, :"node3@127.0.0.1"} ==
               StatePartitioner.Partitioner.for_node("2595efddf3e24bdfb7a7ed6d5cc9bbf9")
    end
  end

  describe "for node with made up nodes" do
    setup do
      nodes =
        ?a..?z
        |> Enum.map(&("node_" <> <<&1>>))
        |> Enum.map(&String.to_atom/1)
        |> Enum.concat([Node.self()])

      %{nodes: nodes}
    end

    test "", %{nodes: nodes} do
      expected = %{
        "a" => {:other, :node_p},
        "b" => {:other, :node_n},
        "c" => {:other, :node_w},
        "d" => {:other, :node_u},
        "e" => :me,
        "f" => {:other, :node_n},
        "g" => {:other, :node_q},
        "h" => {:other, :node_a},
        "i" => {:other, :node_x},
        "j" => {:other, :node_p},
        "k" => {:other, :node_q},
        "l" => {:other, :node_v},
        "m" => {:other, :node_j},
        "n" => {:other, :node_u},
        "o" => {:other, :node_k},
        "p" => {:other, :node_b},
        "q" => {:other, :node_j},
        "r" => {:other, :node_v},
        "s" => {:other, :node_q},
        "t" => {:other, :node_y},
        "u" => {:other, :node_s},
        "v" => {:other, :node_o},
        "w" => {:other, :node_g},
        "x" => {:other, :node_p},
        "y" => {:other, :node_l},
        "z" => {:other, :node_r}
      }

      ?a..?z
      |> Enum.map(&<<&1>>)
      |> Enum.map(fn input ->
        out = StatePartitioner.Partitioner.for_node(input, nodes, "")
        assert Map.fetch!(expected, input) == out
      end)
    end
  end
end
