defmodule Hyperledger.Mixfile do
  use Mix.Project

  def project do
    [app: :hyperledger,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
     compilers: [:phoenix] ++ Mix.compilers,
     deps: deps]
  end
  
  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Hyperledger, []},
     applications: app_list(Mix.env)]
  end

  defp app_list(:dev), do: [:dotenv | app_list]
  defp app_list(_), do: app_list
  defp app_list, do: [:phoenix, :cowboy, :logger, :postgrex, :ecto, :poison, :httpotion]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 0.11.0"},
     {:phoenix_ecto, "~> 0.3"},
     {:cowboy, "~> 1.0"},
     {:postgrex, "~> 0.8"},
     {:dotenv, "~> 0.0.4"},
     {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.1"},
     {:httpotion, "~> 2.0.0"},
     {:mock, "~> 0.1.0"}]
  end
end
