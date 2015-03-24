defmodule Hyperledger.LedgerController do
  use Hyperledger.Web, :controller
  
  alias Hyperledger.Repo
  alias Hyperledger.Ledger
  alias Hyperledger.LogEntry

  plug :action

  def index(conn, _params) do
    ledgers = Repo.all(Ledger)
    render conn, "index.json", ledgers: ledgers
  end
  
  def create(conn, params) do
    json_data = params |> Map.take(["ledger"]) |> Poison.encode!
    LogEntry.create(command: "ledger/create", data: json_data)
    ledger = Repo.get(Ledger, params["ledger"]["hash"])
    conn
    |> put_status(:created)
    |> render "show.json", ledger: ledger
  end
end
