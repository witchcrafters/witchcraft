defmodule Witchcraft.Mixfile do
  use Mix.Project

  def project do
    [app:     :witchcraft,
     name:    "Witchcraft",

     description: "Common algebraic structures and functions",
     package: package,

     version: "0.3.1",
     elixir:  "~> 1.2",

     source_url:   "https://github.com/robot-overlord/witchcraft",
     homepage_url: "https://github.com/robot-overlord/witchcraft",

     # build_embedded:  Mix.env == :prod,
     # start_permanent: Mix.env == :prod,

     deps: deps,
     docs: [logo: "./logo.png",
            extras: ["README.md"]]
    ]
  end

  # def application do
  #   [applications: [:logger]]
  # end

  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.10", only: :dev},
     {:algae, "~> 0.8"},
     {:quark, "~> 1.0"}
    ]
  end

  defp package do
    [maintainers: ["Brooklyn Zelenka", "Jennifer Cooper"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/robot-overlord/witchcraft",
              "Docs" => "http://robot-overlord.github.io/witchcraft/"}]
  end
end
