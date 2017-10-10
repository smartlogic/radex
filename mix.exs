defmodule Radex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :radex,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      description: description(),
      package: package(),
      source_url: "https://github.com/smartlogic/radex"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Radex.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.17", only: :dev, runtime: false},
      {:plug, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:temp, "~> 0.4", only: :test}
    ]
  end

  def description() do
    "Generate API documentation based on your tests."
  end

  def package() do
    [
      maintainers: ["Eric Oestrich"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/smartlogic/radex"}
    ]
  end
end
