defmodule Hyperledger.IssueControllerTest do
  use HyperledgerTest.Case
  use Ecto.Model
  
  alias Hyperledger.Issue
  alias Hyperledger.Ledger
  alias Hyperledger.LogEntry
  alias Hyperledger.Repo

  setup do
    create_primary
    {:ok, ledger} = Ledger.create hash: "123",
                      public_key: "abc",
                      primary_account_public_key: "def"
    {:ok, ledger: ledger}
  end

  test "GET ledger issues" do
    conn = call(:get, "/ledgers/123/issues", [{"content-type", "application/json"}])
    assert conn.status == 200
  end
  
  test "POST /ledger/{id}/issues creates log entry and increases the primary wallet balance", %{ledger: ledger} do
    body = %{issue: %{uuid: Ecto.UUID.generate, ledgerHash: "123", amount: 100}}
    conn = call(:post, "/ledgers/#{ledger.hash}/issues", body, [{"content-type", "application/json"}])
    
    assert conn.status == 201
    assert Repo.all(Issue)    |> Enum.count == 1
    assert Repo.all(LogEntry) |> Enum.count == 1
    assert Repo.one(assoc(ledger, :primary_account)).balance == 100
  end
end
