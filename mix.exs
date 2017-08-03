defmodule Witchcraft.Mixfile do
  use Mix.Project

  def project do
    [
      app:  :witchcraft,
      name: "Witchcraft",
      description: "Common algebras (monoids, functors, monads, &c)",

      version: "1.0.0-beta.3",
      elixir:  "~> 1.5",

      package: [
        maintainers: ["Brooklyn Zelenka"],
        licenses:    ["MIT"],
        links:       %{"GitHub" => "https://github.com/expede/witchcraft"}
      ],

      source_url:   "https://github.com/expede/witchcraft",
      homepage_url: "https://github.com/expede/witchcraft",

      aliases: ["quality": ["test", "credo --strict", "inch"]],

      deps: [
        {:credo,      "~> 0.8", only: [:dev, :test]},
        {:benchfella, "~> 0.3", only: [:dev, :test]},

        {:dialyxir, "~> 0.3",  only: :dev},
        {:earmark,  "~> 1.2",  only: :dev},
        {:ex_doc,   "~> 0.15", only: :dev},

        {:inch_ex, "~> 0.5",  only: [:dev, :docs, :test]},

        {:exceptional, "~> 2.1"},
        {:operator,    "~> 0.2"},
        {:quark,       "~> 2.2"},
        {:type_class,  "~> 1.2"}
      ],

      docs: [
        extras: ["README.md"],
        logo: "./brand/Icon/PNG/WC-icon-sml@2x-circle.png",
        main: "readme"
      ]
    ]
  end
end
