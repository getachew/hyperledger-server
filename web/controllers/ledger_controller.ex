defmodule Hyperledger.LedgerController do
  use Hyperledger.Web, :controller
  
  alias Hyperledger.Repo
  alias Hyperledger.Ledger
  alias Hyperledger.LogEntry

  plug Hyperledger.Authentication when action in [:create]
  plug :action

  def index(conn, _params) do
    ledgers = Repo.all(Ledger)
    render conn, :index, ledgers: ledgers
  end
  
  def create(conn, params) do
    log_entry = %{
      command: "ledger/create",
      data: conn.private.raw_json_body,
      authentication_key: conn.assigns[:authentication_key],
      signature: conn.assigns[:signature]
    }
    changeset = LogEntry.changeset(%LogEntry{}, log_entry)
    
    if changeset.valid? do
      LogEntry.create(
        command: "ledger/create",
        data: conn.private.raw_json_body
      )
      ledger = Repo.get(Ledger, params["ledger"]["hash"])
      conn
      |> put_status(:created)
      |> render :show, ledger: ledger
    else
      conn
      |> put_status(:unprocessable_entity)
      |> halt
    end
  end
end
