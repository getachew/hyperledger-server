defmodule Hyperledger.LedgerController do
  use Phoenix.Controller

  plug :action

  def index(conn, _params) do
    ledgers = Hyperledger.Repo.all(Hyperledger.Ledger)
    json conn, serialize(ledgers, conn)
  end
  
  def create(conn, params) do
    %{"ledger" => %{"hash" => hash, "publicKey" => public_key}} = params
    ledger = Hyperledger.Repo.insert(%Hyperledger.Ledger{hash: hash, public_key: public_key})
    json conn, serialize(ledger, conn)
  end
  
  defp serialize(obj, conn) do
    obj
    |> Hyperledger.LedgerSerializer.as_json(conn, %{})
    |> Poison.encode!
  end
end
