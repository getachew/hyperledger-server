defmodule Hyperledger.AccountControllerTest do
  use HyperledgerTest.Case
  
  alias Hyperledger.Ledger
  alias Hyperledger.Account
  alias Hyperledger.LogEntry
  alias Hyperledger.Repo

  setup do
    create_primary
    Ledger.create hash: "123", public_key: "abc", primary_account_public_key: "def"
    :ok
  end

  test "GET ledger accounts" do
    conn = call(:get, "/accounts", [{"content-type", "application/json"}])
    assert conn.status == 200
  end
  
  test "POST /accounts creates log entry and account" do
    body = %{account: %{publicKey: "abc", ledgerHash: "123"}}
    conn = call(:post, "/accounts", body, [{"content-type", "application/json"}])
    
    assert conn.status == 201
    assert Repo.all(Account)  |> Enum.count == 2
    assert Repo.all(LogEntry) |> Enum.count == 1
  end
end
