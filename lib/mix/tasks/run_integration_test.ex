defmodule Mix.Tasks.TestIntegration do
  @moduledoc "Run integration tests, this will also setup a cluster which we can use in these tests"
  @shortdoc "run integration tests"
  @preferred_cli_env :test_integration

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    Mix.shell().cmd("epmd -daemon")
    :ok = LocalCluster.start()
    Application.ensure_all_started(:state_partitioner)
    _nodes = LocalCluster.start_nodes("node", 3)

    try do
      Mix.Tasks.Test.run(["--no-start", "test/integration" | args])
    after
      :ok = LocalCluster.stop()
    end
  end
end
