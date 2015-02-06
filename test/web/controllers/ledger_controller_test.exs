defmodule Hyperledger.LedgerControllerTest do
  use HyperledgerTest.Case
    
  alias Hyperledger.Router
  alias Hyperledger.Repo
  alias Hyperledger.Node
  alias Hyperledger.LogEntry
  alias Hyperledger.Ledger
  
  setup do
    System.put_env("NODE_URL", "http://localhost")
    %Node{url: "http://localhost", public_key: "abc"}
    |> Repo.insert
    :ok
  end
  
  test "list ledgers" do
    conn = call(Router, :get, "/ledgers")
    assert conn.status == 200
  end
  
  test "create ledger through log entry" do
    body = %{ledger: %{hash: "123", publicKey: "abc", primaryAccountPublicKey: "def"}}
    conn = call(Router, :post, "/ledgers", body,
      headers: [{"content-type", "application/json"}])
    
    assert conn.status == 201
    assert Repo.all(Ledger)   |> Enum.count == 1
    assert Repo.all(LogEntry) |> Enum.count == 1
  end
    
end
