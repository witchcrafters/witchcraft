defmodule Witchcraft.Mixfile do
  use Mix.Project

  def project do
    [app:     :witchcraft,
     name:    "Witchcraft",

     version: "0.1.0",
     elixir:  "~> 1.1",

     source_url:   "https://github.com/robot-overlord/witchcraft",
     homepage_url: "https://github.com/robot-overlord/witchcraft",

     build_embedded:  Mix.env == :prod,
     start_permanent: Mix.env == :prod,

     deps: deps,
     docs: [#logo: "path/to/logo.png",
           extras: ["README.md"]]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.10", only: :dev}]
  end
end
