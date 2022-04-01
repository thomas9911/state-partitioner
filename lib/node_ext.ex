defmodule NodeExt do
  @moduledoc """
  Helpers for Node module
  """

  @spec list_all() :: [atom]
  def list_all do
    Node.list([:this, :visible])
  end

  @spec hash_ordered_list_with_hash([atom], binary) :: [{binary, binary}]
  def hash_ordered_list_with_hash(node_list \\ list_all(), prefix \\ prefix()) do
    node_list
    |> Enum.map(&to_string/1)
    |> Enum.filter(&app_filter(&1, prefix))
    |> Enum.map(&{:crypto.hash(:sha256, &1), &1})
    |> Enum.sort_by(&elem(&1, 0))
  end

  @spec hash_ordered_list([atom], binary) :: [binary]
  def hash_ordered_list(node_list \\ list_all(), prefix \\ prefix()) do
    node_list
    |> hash_ordered_list_with_hash(prefix)
    |> Enum.map(&elem(&1, 1))
  end

  @spec hash_ordered_list([atom], binary) :: pos_integer | nil
  def self_index(node_list \\ list_all(), prefix \\ prefix()) do
    node_list
    |> hash_ordered_list(prefix)
    |> Enum.find_index(&(&1 == to_string(Node.self())))
  end

  @spec app_filter(binary, binary) :: boolean
  defp app_filter(_, ""), do: true

  defp app_filter(node_name, nil) do
    String.starts_with?(node_name, prefix())
  end

  defp app_filter(node_name, prefix) do
    String.starts_with?(node_name, prefix)
  end

  @spec prefix() :: binary
  defp prefix do
    Application.get_env(:state_partitioner, :app_filter_prefix, "")
  end
end
