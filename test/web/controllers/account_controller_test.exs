defmodule Hyperledger.AccountControllerTest do
  use Hyperledger.ConnCase
  
  alias Hyperledger.Account
  alias Hyperledger.LogEntry

  setup do
    create_primary
    {:ok, ledger} = create_ledger
    {:ok, ledger: ledger}
  end

  test "GET ledger accounts" do
    conn = get conn(), "/accounts"
    assert conn.status == 200
  end
  
  test "POST /accounts creates log entry and account", %{ledger: ledger} do
    {pk, _sk} = :crypto.generate_key(:ecdh, :secp256k1)
    body = %{account: %{publicKey: Base.encode32(pk), ledgerHash: ledger.hash}}
    conn = post conn(), "/accounts", body
    
    assert conn.status == 201
    assert Repo.all(Account)  |> Enum.count == 2
    assert Repo.all(LogEntry) |> Enum.count == 1
  end
end
