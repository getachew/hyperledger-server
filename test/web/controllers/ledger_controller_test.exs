defmodule Hyperledger.LedgerControllerTest do
  use HyperledgerTest.Case
    
  alias Hyperledger.Repo
  alias Hyperledger.LogEntry
  alias Hyperledger.Ledger
  
  setup do
    create_primary
    :ok
  end
  
  test "list ledgers" do
    conn = call(:get, "/ledgers")
    assert conn.status == 200
  end
  
  test "create ledger through log entry" do
    body = %{ledger: %{hash: "123", publicKey: "abc", primaryAccountPublicKey: "def"}}
    conn = call(:post, "/ledgers", body, [{"content-type", "application/json"}])
    
    assert conn.status == 201
    assert Repo.all(Ledger)   |> Enum.count == 1
    assert Repo.all(LogEntry) |> Enum.count == 1
  end
end
