defmodule Witchcraft.Mixfile do
  use Mix.Project

  def project do
    [
      app: :witchcraft,
      name: "Witchcraft",
      description: "Monads and other dark magic (monoids, functors, traversables, &c)",
      version: "1.0.1",
      elixir: "~> 1.5",
      package: [
        maintainers: ["Brooklyn Zelenka"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/expede/witchcraft"}
      ],
      source_url: "https://github.com/expede/witchcraft",
      homepage_url: "https://github.com/expede/witchcraft",
      aliases: [quality: ["test", "credo --strict", "inch"]],
      deps: [
        {:inch_ex, "~> 0.5", only: [:dev, :docs, :test]},
        {:credo, "~> 0.8", only: [:dev, :test]},
        {:benchfella, "~> 0.3", only: [:dev, :test]},
        {:dialyxir, "~> 0.3", only: :dev},
        {:earmark, "~> 1.2", only: :dev},
        {:ex_doc, "~> 0.15", only: :dev},
        {:exceptional, "~> 2.1"},
        {:operator, "~> 0.2"},
        {:quark, "~> 2.2"},
        {:type_class, "~> 1.2"}
      ],
      docs: [
        extras: ["README.md"],
        logo: "./brand/Icon/PNG/WC-icon-sml@2x-circle.png",
        main: "readme"
      ]
    ]
  end
end
