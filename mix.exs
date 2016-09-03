defmodule Witchcraft.Mixfile do
  use Mix.Project

  def project do
    [
      app:  :witchcraft,
      name: "Witchcraft",
      description: "Common algebraic structures and functions",

      version: "0.5.0",
      elixir:  "~> 1.3",

      package: [
        maintainers: ["Brooklyn Zelenka"],
        licenses:    ["MIT"],
        links:       %{"GitHub" => "https://github.com/expede/quark"}
      ],

      source_url:   "https://github.com/expede/quark",
      homepage_url: "https://github.com/expede/quark",

      aliases: ["quality": ["test", "credo --strict"]],

      deps: [
        {:credo,    "~> 0.4",  only: [:dev, :test]},

        {:dialyxir, "~> 0.3",  only: :dev},
        {:earmark,  "~> 1.0",  only: :dev},
        {:ex_doc,   "~> 0.13", only: :dev},

        {:inch_ex,  "~> 0.5",  only: [:dev, :docs, :test]},

        {:algae, "~> 0.9"},
        {:quark, "~> 1.0"}
      ],

      docs: [
        logo: "./brand/logo.png",
        extras: ["README.md"]
      ]
    ]
  end
end
