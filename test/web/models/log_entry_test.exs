defmodule Hyperledger.LogEntryModelTest do
  use HyperledgerTest.Case
  use Ecto.Model
  
  alias Hyperledger.Repo
  alias Hyperledger.LogEntry
  alias Hyperledger.Ledger
  alias Hyperledger.Account
  alias Hyperledger.Issue
  alias Hyperledger.Transfer
  alias Hyperledger.Node
  
  setup do
    System.put_env("NODE_URL", "http://localhost")
    %Node{url: "http://localhost", public_key: "abc"} |> Repo.insert
    :ok
  end
  
  test "creating a log entry also appends a prepare confirmation from self" do    
    {:ok, data} = %{ledger:
                    %{hash: "123",
                      publicKey: "abc",
                      primaryAccountPublicKey: "cde"}}
                  |> Poison.encode
    
    {:ok, log_entry} = LogEntry.create command: "ledger/create", data: data
    
    assert Repo.all(assoc(log_entry, :prepare_confirmations)) |> Enum.count == 1
  end
  
  test "log entries create ledgers with a primary account" do
    {:ok, data} = %{ledger: %{hash: "123", publicKey: "abc", primaryAccountPublicKey: "cde"}}
                  |> Poison.encode
    
    LogEntry.create command: "ledger/create", data: data
    
    assert Repo.all(LogEntry) |> Enum.count == 1
    assert Repo.all(Ledger)   |> Enum.count == 1
    assert Repo.all(Account)  |> Enum.count == 1
  end
  
  test "log entries create accounts" do
    {:ok, data} = %{account: %{ledgerHash: "abc", publicKey: "cde"}}
                  |> Poison.encode
    
    LogEntry.create command: "account/create", data: data
    
    assert Repo.all(LogEntry) |> Enum.count == 1
    assert Repo.all(Account)  |> Enum.count == 1
  end
  
  test "log entries create issues and change primary wallet balances" do
    Ledger.create(hash: "123", public_key: "abc", primary_account_public_key: "cde")
    {:ok, data} = %{issue:
                    %{uuid: UUID.uuid4,
                      ledgerHash: "123",
                      amount: 100}}
                  |> Poison.encode
    
    LogEntry.create command: "issue/create", data: data
    
    assert Repo.all(LogEntry) |> Enum.count == 1
    assert Repo.all(Issue)    |> Enum.count == 1
    assert Repo.get(Account, "cde").balance == 100
  end
  
  test "log entries create transfers and change wallet balances" do
    Ledger.create(hash: "123", public_key: "abc", primary_account_public_key: "cde")
    Issue.create(uuid: UUID.uuid4, ledger_hash: "123", amount: 100)
    %Account{public_key: "def", ledger_hash: "123"} |> Repo.insert
    
    {:ok, data} = %{transfer:
                    %{uuid: UUID.uuid4,
                      amount: 100,
                      sourcePublicKey: "cde",
                      destinationPublicKey: "def"}}
                  |> Poison.encode
    
    LogEntry.create command: "transfer/create", data: data
    
    assert Repo.all(Transfer)    |> Enum.count == 1
    assert Repo.get(Account, "cde").balance == 0
    assert Repo.get(Account, "def").balance == 100
  end
end