defmodule Hyperledger.AccountControllerTest do
  use Hyperledger.ConnCase
  
  alias Hyperledger.Account
  alias Hyperledger.LogEntry

  setup do
    create_primary
    create_ledger
    :ok
  end

  test "GET ledger accounts" do
    conn = get conn(), "/accounts"
    assert conn.status == 200
  end
  
  test "POST /accounts creates log entry and account" do
    body = %{account: %{publicKey: "abc", ledgerHash: "123"}}
    conn = post conn(), "/accounts", body
    
    assert conn.status == 201
    assert Repo.all(Account)  |> Enum.count == 2
    assert Repo.all(LogEntry) |> Enum.count == 1
  end
end
