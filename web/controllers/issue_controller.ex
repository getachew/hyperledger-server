defmodule Hyperledger.IssueController do
  use Phoenix.Controller

  plug :action

  def create(conn, params) do
    %{"issue" => %{"amount" => amount, "uuid" => uuid}} = params
    issue = %Hyperledger.Issue{
      amount: amount, uuid: uuid, ledger_hash: params["ledger_hash"]}
      |> Hyperledger.Repo.insert
    json conn, serialize(issue, conn)
  end
  
  defp serialize(obj, conn) do
    obj
    |> Hyperledger.IssueSerializer.as_json(conn, %{})
    |> Poison.encode!
  end
end
