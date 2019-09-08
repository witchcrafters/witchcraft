defmodule Witchcraft.Mixfile do
  use Mix.Project

  def project do
    [
      app: :witchcraft,
      aliases: aliases(),
      deps: deps(),

      # Versions
      version: "1.0.2",
      elixir: "~> 1.9",

      # Docs
      name: "Witchcraft",
      docs: docs(),

      # Hex
      description: "Monads and other dark magic (monoids, functors, traversables, &c)",
      package: package()
    ]
  end

  defp aliases do
    [
      quality: ["test", "credo --strict", "inch"]
    ]
  end

  defp deps do
    [
      {:inch_ex, "~> 2.0", only: [:dev, :docs, :test]},
      {:credo, "~> 1.1.4", only: [:dev, :test]},
      {:benchfella, "~> 0.3", only: [:dev, :test]},
      {:dialyxir, "~> 0.3", only: :dev},
      {:earmark, "~> 1.4.0", only: :dev},
      {:ex_doc, "~> 0.21.2", only: :dev},
      {:exceptional, "~> 2.1"},
      {:operator, "~> 0.2"},
      {:quark, "~> 2.2"},
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
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/witchcrafters/witchcraft"},
      maintainers: ["Brooklyn Zelenka", "Steven Vandevelde"],
      organization: "witchcrafters"
    ]
  end
end
