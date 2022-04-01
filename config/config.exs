import Config

if "#{config_env()}.exs" |> Path.expand("config") |> File.exists?() do
  import_config "#{config_env()}.exs"
end
