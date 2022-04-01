defmodule StatePartitioner.Partitioner do
  @moduledoc """
  Module that determines on some index/input that the message is for this node or another one
  """

  @doc """
  Collapse the input into an node index.
  Uses this formula: node_index = crc32(message_id) % amount_of_nodes
  """
  def collapse_input(input, amount) do
    rem(:erlang.crc32(input), amount)
  end

  # defp for_me_comparison(input, partitions, my_partition) do
  #   collapse_input(input, partitions) == my_partition
  # end

  # def for_me?(input) do
  #   if for_me_comparison(input, length(NodeExt.list_all()), NodeExt.self_index()) do
  #     true
  #   else
  #     false
  #   end
  # end

  @spec for_node(binary, [atom], binary | nil) :: {:other, atom} | :me
  def for_node(input, node_list \\ NodeExt.list_all(), prefix \\ nil) do
    my_index = NodeExt.self_index(node_list, prefix)
    sorted_nodes = NodeExt.hash_ordered_list(node_list, prefix)

    case collapse_input(input, length(sorted_nodes)) do
      ^my_index ->
        :me

      index ->
        other_node =
          sorted_nodes
          |> Enum.at(index)
          |> String.to_existing_atom()

        {:other, other_node}
    end
  end
end
