defmodule StatePartitioner.MixProject do
  use Mix.Project

  def project do
    [
      app: :state_partitioner,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      preferred_cli_env: [
        "test.i": :test_integration,
        "test.u": :test,
        "test.original": :test
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {StatePartitioner.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:libcluster, "~> 3.3"},
      {:local_cluster, "~> 1.2", only: [:test, :test_integration]}
    ]
  end

  defp aliases do
    [
      test: [
        &run_unit_test/1,
        &run_integration_test/1
      ],
      "test.i": &run_integration_test/1,
      "test.u": &run_unit_test/1,
      "test.original": &run_test/1
    ]
  end

  defp run_unit_test(args) do
    Mix.Tasks.Test.run(["test/unit" | args])
  end

  defp run_integration_test(args) do
    args = if IO.ANSI.enabled?(), do: ["--color" | args], else: ["--no-color" | args]

    {_, res} =
      System.cmd("mix", ["test_integration" | args],
        into: IO.binstream(:stdio, :line),
        env: [{"MIX_ENV", "test_integration"}]
      )

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end
  end

  defp run_test(args) do
    Mix.Tasks.Test.run(args)
  end
end
