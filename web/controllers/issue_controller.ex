defmodule Hyperledger.IssueController do
  use Hyperledger.Web, :controller
  use Ecto.Model
  
  alias Hyperledger.Issue
  alias Hyperledger.Ledger
  alias Hyperledger.LogEntry
  alias Hyperledger.Repo
  
  plug :action
  
  def index(conn, params) do
    ledger = Repo.get(Ledger, params["ledger_id"])
    issues = Repo.all(assoc(ledger, :issues))
    render conn, :index, issues: issues, ledger: ledger
  end

  def create(conn, params) do
    json_data = params |> Map.take(["issue"]) |> Poison.encode!
    LogEntry.create(command: "issue/create", data: json_data)
    issue = Repo.get(Issue, params["issue"]["uuid"])
    conn
    |> put_status(:created)
    |> render :show, issue: issue
  end
end
