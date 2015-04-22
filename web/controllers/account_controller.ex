defmodule Hyperledger.AccountController do
  use Hyperledger.Web, :controller
  use Ecto.Model
  
  alias Hyperledger.Repo
  alias Hyperledger.Account
  alias Hyperledger.LogEntry
  
  plug :action

  def index(conn, _params) do
    accounts = Repo.all(Account)
    render conn, :index, accounts: accounts
  end
  
  def show(conn, params) do
    account = Repo.first(Acccount, params["id"])
    render conn, :show, account: account
  end
  

  def create(conn, params) do
    json_data = params |> Map.take(["account"]) |> Poison.encode!
    LogEntry.create(command: "account/create", data: json_data)
    account = Repo.get(Account, params["account"]["publicKey"])
    conn
    |> put_status(:created)
    |> render :show, account: account
  end
end
