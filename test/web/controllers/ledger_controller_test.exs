defmodule Hyperledger.LedgerControllerTest do
  use Hyperledger.ConnCase
    
  alias Hyperledger.LogEntry
  alias Hyperledger.Ledger
  
  setup do
    create_primary
    :ok
  end
  
  test "list ledgers" do
    conn = get conn(), "/ledgers"
    assert conn.status == 200
  end
    
  test "create ledger through log entry" do
    conn =
      conn()
      |> put_req_header("content-type", "application/json")
      |> post "/ledgers", Poison.encode!(ledger_params)
    
    assert conn.status == 201
    assert Repo.all(LogEntry) |> Enum.count == 1
    assert Repo.all(Ledger)   |> Enum.count == 1
  end
end
