defmodule Hyperledger.AccountController do
  use Hyperledger.Web, :controller
  use Ecto.Model
  
  alias Hyperledger.Repo
  alias Hyperledger.Ledger
  alias Hyperledger.Account
  
  plug :action

  def index(conn, params) do
    ledger = Repo.get(Ledger, params["ledger_id"])
    accounts = Repo.all assoc(ledger, :accounts)
    json conn, serialize(accounts, conn)
  end

  def show(conn, params) do
    account = Repo.get(Account, params["account_id"])
    json conn, serialize(account, conn)
  end

  def create(conn, params) do
    %{"account" => %{"publicKey" => public_key}} = params
    ledger = %Account{
      public_key: public_key,
      ledger_hash: params["ledger_hash"],
      balance: 0}
      |> Repo.insert
    json conn, serialize(ledger, conn)
  end
  
  defp serialize(obj, conn) do
    obj
    |> Hyperledger.AccountSerializer.as_json(conn, %{})
    |> Poison.encode!
  end
end
