defmodule Hyperledger.IssueControllerTest do
  use Hyperledger.ConnCase
  
  alias Hyperledger.Issue
  alias Hyperledger.LogEntry

  setup do
    create_primary
    {:ok, ledger} = create_ledger
    {:ok, ledger: ledger}
  end

  test "GET ledger issues" do
    conn = get conn(), "/ledgers/123/issues"
    assert conn.status == 200
  end
  
  test "POST /ledger/{id}/issues creates log entry and increases the primary wallet balance", %{ledger: ledger} do
    body = %{issue: %{uuid: Ecto.UUID.generate, ledgerHash: "123", amount: 100}}
    conn = post conn(), "/ledgers/#{ledger.hash}/issues", body
    
    assert conn.status == 201
    assert Repo.all(Issue)    |> Enum.count == 1
    assert Repo.all(LogEntry) |> Enum.count == 1
    assert Repo.one(assoc(ledger, :primary_account)).balance == 100
  end
end
