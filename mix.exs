defmodule Witchcraft.Mixfile do
  use Mix.Project

  def project do
    [
      app:  :witchcraft,
      name: "Witchcraft",
      description: "Common algebras (monoids, functors, monads, &c)",

      version: "0.6.0",
      elixir:  "~> 1.3",

      package: [
        maintainers: ["Brooklyn Zelenka"],
        licenses:    ["MIT"],
        links:       %{"GitHub" => "https://github.com/expede/witchcraft"}
      ],

      source_url:   "https://github.com/expede/witchcraft",
      homepage_url: "https://github.com/expede/witchcraft",

      aliases: ["quality": ["test", "credo --strict"]],

      deps: [
        {:credo,    "~> 0.4",  only: [:dev, :test]},

        {:dialyxir, "~> 0.3",  only: :dev},
        {:earmark,  "~> 1.0",  only: :dev},
        {:ex_doc,   "~> 0.13", only: :dev},

        {:inch_ex, "~> 0.5",  only: [:dev, :docs, :test]},

        {:algae,       "~> 0.12"},
        {:exceptional, "~> 2.0"},
        {:operator,    "~> 0.2"},
        {:quark,       "~> 2.1"},
        {:type_class, github: "expede/type_class", branch: "function_cases"}
      ],

      docs: [
        extras: ["README.md"],
        logo: "./brand/logo.png",
        main: "readme"
      ]
    ]
  end
end
