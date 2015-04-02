defmodule Hyperledger.TransferController do
  use Hyperledger.Web, :controller
  use Ecto.Model
  
  alias Hyperledger.Transfer
  alias Hyperledger.LogEntry
  alias Hyperledger.Repo
  
  plug :action

  def index(conn, _params) do
    transfers = Repo.all(Transfer)
    render conn, "index.json", transfers: transfers
  end
  
  def create(conn, params) do
    json_data = params |> Map.take(["transfer"]) |> Poison.encode!
    LogEntry.create(command: "transfer/create", data: json_data)
    transfer = Repo.get(Transfer, params["transfer"]["uuid"])
    conn
    |> put_status(:created)
    |> render "show.json", transfer: transfer
  end
end
