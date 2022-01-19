defmodule Witchcraft.Mixfile do
  use Mix.Project

  def project do
    [
      app: :doma_witchcraft,
      aliases: aliases(),
      deps: deps(),
      preferred_cli_env: [quality: :test],

      # Versions
      version: "1.0.4-doma",
      elixir: "~> 1.9",

      # Docs
      name: "Witchcraft",
      docs: docs(),

      # Hex
      description:
        "Monads and other dark magic (monoids, functors, traversables, &c), forked by doma for maintenance and testing packagesets",
      package: package()
    ]
  end

  defp aliases do
    [
      quality: [
        "test",
        "credo --strict"
      ]
    ]
  end

  defp deps do
    [
      {:benchfella, "~> 0.3", only: [:dev, :test]},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:inch_ex, "~> 2.0", only: [:dev, :docs, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: :dev, runtime: false},
      {:earmark, "~> 1.4", only: :dev, runtime: false},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:exceptional, "~> 2.1"},
      {:operator, "~> 0.2"},
      {:doma_quark, "~> 2.3.2-doma2"},
      {:type_class, "~> 1.2"}
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      logo: "./brand/Icon/PNG/WC-icon-sml@2x-circle.png",
      main: "readme",
      source_url: "https://github.com/witchcrafters/witchcraft"
    ]
  end

  defp package do
    [
      name: "doma_witchcraft",
      licenses: ["Apache-2.0"],
      links: %{
        "Github" => "https://github.com/doma-engineering/witchcraft",
        "Upstream" => "https://github.com/witchcrafters/witchcraft"
      },
      maintainers: ["Jonn Mostovoy"]
    ]
  end
end
