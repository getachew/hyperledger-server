defmodule Hyperledger.Repo do
  use Ecto.Repo,
    otp_app: :hyperledger,
    adapter: Ecto.Adapters.Postgres
    
  def priv do
    app_dir(:hyperledger, "priv/repo")
  end
end
