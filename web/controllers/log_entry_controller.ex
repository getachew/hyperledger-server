defmodule Hyperledger.LogEntryController do
  use Phoenix.Controller
  
  alias Hyperledger.Repo
  alias Hyperledger.LogEntry

  plug :action

  def index(conn, _params) do
    entries = Repo.all(LogEntry)
    render conn, "index.json", entries: entries
  end
  
  def create(conn, params) do
    %{"logEntry" => %{"id" => id, "view" => view,
      "command" => command, "data" => data}} = params
      
    case LogEntry.insert(id: id, view: view, command: command, data: data) do
      {:ok, log_entry} ->
        conn
        |> put_status(:created)
        |> render "show.json", entry: log_entry
      {:error, _} ->
        conn
        |> put_status(:forbidden)
        |> render "error.json"
    end
  end
end
