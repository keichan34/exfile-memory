defmodule ExfileMemory.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exfile_memory,
      version: "0.0.1",
      elixir: "~> 1.2.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      package: package,
      description: description
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      mod: {ExfileMemory, []},
      applications: [
        :logger,
        :crypto,
        :exfile
      ]
    ]
  end

  defp deps do
    [
      {:exfile, "~> 0.1.0"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Keitaroh Kobayashi"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/keichan34/exfile-memory"
      }
    ]
  end

  defp description do
    """
    In-memory (ets) storage backend for Exfile.
    """
  end
end
