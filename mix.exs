defmodule Healthchex.MixProject do
  use Mix.Project

  def project do
    [
      app: :healthchex,
      version: "0.2.1",
      elixir: "~> 1.11",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:plug_cowboy, "~> 2.4"}
    ]
  end

  defp description,
    do: "A set of Plugs to be used for Kubernetes healthchecks."

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/KamilLelonek/healthchex"}
    ]
  end
end
