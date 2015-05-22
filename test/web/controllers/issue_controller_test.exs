defmodule Hyperledger.IssueControllerTest do
  use Hyperledger.ConnCase
  
  alias Hyperledger.Issue
  alias Hyperledger.LogEntry

  setup do
    create_primary
    {:ok, ledger} = create_ledger
    {:ok, ledger: ledger}
  end

  test "GET ledger issues", %{ledger: ledger} do
    conn = get conn(), "/ledgers/#{ledger.hash}/issues"
    assert conn.status == 200
  end
  
  test "POST /ledger/{id}/issues creates log entry and increases the primary wallet balance", %{ledger: ledger} do
    body = %{issue: %{uuid: Ecto.UUID.generate, ledgerHash: ledger.hash, amount: 100}}
    conn = conn()
      |> put_req_header("content-type", "application/json")
      |> post("/ledgers/#{ledger.hash}/issues", Poison.encode!(body))
    
    assert conn.status == 201
    assert Repo.all(Issue)    |> Enum.count == 1
    assert Repo.all(LogEntry) |> Enum.count == 1
    assert Repo.one(assoc(ledger, :primary_account)).balance == 100
  end
end
