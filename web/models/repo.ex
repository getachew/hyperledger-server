defmodule Hyperledger.Repo do
  use Ecto.Repo,
    otp_app: :hyperledger,
    adapter: Ecto.Adapters.Postgres
end
