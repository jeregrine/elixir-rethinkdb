defmodule Rethinkdb.Mixfile do
  use Mix.Project

  def project do
    [ app: :rethinkdb,
      version: "0.2.3",
      elixir: "~> 1.0",
      deps: deps,

      # Hex
      description: description,
      package: package
    ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { Rethinkdb.App, [] },
      applications: []
    ]
  end

  defp deps() do
    [
      {:exprotobuf, "~> 0.8.5"},
      {:gpb, github: "tomas-abrahamsson/gpb", tag: "3.17.2"},
      {:ex_doc, github: "elixir-lang/ex_doc", only: :docs},
      {:mock, "~> 0.1.0", only: :test}
    ]
  end

  defp description do
    """
    Client application for Rethinkdb
    """
  end

  defp package do
    [contributors: ["Everton Ribeiro"],
      licenses: ["Apache 2.0", "Bitdeli Chef", ],
      links: %{"GitHub" => "https://github.com/azukiapp/elixir-rethinkdb"}]
  end
end
