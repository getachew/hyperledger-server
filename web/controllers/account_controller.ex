defmodule Hyperledger.AccountController do
  use Phoenix.Controller

  plug :action

  def index(conn, params) do
    ledger = Hyperledger.Repo.get(Hyperledger.Ledger, params["ledger_id"])
    accounts = Hyperledger.Repo.all(ledger.accounts)
    json conn, serialize(accounts, conn)
  end

  def show(conn, params) do
    account = Hyperledger.Repo.get(Hyperledger.Account, params["account_id"])
    json conn, serialize(account, conn)
  end

  def create(conn, params) do
    %{"account" => %{"publicKey" => public_key}} = params
    ledger = %Hyperledger.Account{
      public_key: public_key,
      ledger_hash: params["ledger_hash"],
      balance: 0}
      |> Hyperledger.Repo.insert
    json conn, serialize(ledger, conn)
  end
  
  defp serialize(obj, conn) do
    obj
    |> Hyperledger.AccountSerializer.as_json(conn, %{})
    |> Poison.encode!
  end
end
