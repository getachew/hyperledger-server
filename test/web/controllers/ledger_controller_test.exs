defmodule Hyperledger.LedgerControllerTest do
  use Hyperledger.ConnCase
    
  alias Hyperledger.LogEntry
  alias Hyperledger.Ledger
  
  setup do
    create_primary
    {:ok, ledger_params("123", true)}
  end
  
  test "list ledgers" do
    conn = get conn(), "/ledgers"
    assert conn.status == 200
  end
    
  test "create ledger through log entry when authenticated", %{ledger: ledger, auth: auth, sig: sig} do
    conn =
      conn()
      |> put_req_header("content-type", "application/json")
      |> put_req_header("authorization", "Hyper Key=#{auth}, Signature=#{sig}")
      |> post "/ledgers", Poison.encode!(%{ledger: ledger})
    
    assert conn.status == 201
    assert Repo.all(LogEntry) |> Enum.count == 1
    assert Repo.all(Ledger)   |> Enum.count == 1
  end
    
  test "error when attempting to create ledger with bad auth", %{ledger: ledger, sig: sig} do
    conn =
      conn()
      |> put_req_header("content-type", "application/json")
      |> put_req_header("authorization", "Hyper Key=000000, Signature=#{sig}")
      |> post "/ledgers", Poison.encode!(%{ledger: ledger})
    
    assert conn.status == 422
    assert Repo.all(LogEntry) |> Enum.count == 0
    assert Repo.all(Ledger)   |> Enum.count == 0
  end
end
