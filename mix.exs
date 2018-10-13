defmodule SpartanKick.MixProject do
  use Mix.Project

  def project do
    [
      app: :spartan_kick,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SpartanKick.Application, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:plug, "~> 1.6"},
      {:poison, "~> 4.0"},
      {:httpoison, "~> 1.3"}

    ]
  end
end
