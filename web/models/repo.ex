defmodule Hyperledger.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do
    parse_url "ecto://daniel@localhost/hl_dev"
  end

  def priv do
    app_dir(:hyperledger, "priv/repo")
  end
end
