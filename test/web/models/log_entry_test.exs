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
    {:ok, data} = %{ledger: %{hash: "123", publicKey: "abc", primaryAccountPublicKey: "cde"}}
                  |> Poison.encode
    {:ok, log_entry} = LogEntry.create command: "ledger/create", data: data
        
    assert Repo.all(assoc(log_entry, :prepare_confirmations)) |> Enum.count == 1
  end
  
  test "when a log entry passes the quorum for prepare confirmations it is marked as prepared" do
    node = %Node{url: "http://localhost-2", public_key: "abc"} |> Repo.insert
    {:ok, log_entry} = LogEntry.create command: "ledger/create", data: "{}"
    
    assert log_entry.prepared == false
    
    LogEntry.add_prepare(log_entry, signature: "temp_signature", node_id: node.id)
    
    assert Repo.get(LogEntry, log_entry.id).prepared == true
  end
  
  test "when a log entry is marked as prepared the node adds a commit confirmation" do
    node = %Node{url: "http://localhost-2", public_key: "abc"} |> Repo.insert
    {:ok, log_entry} = LogEntry.create command: "ledger/create", data: "{}"

    assert Repo.all(assoc(log_entry, :commit_confirmations)) == []
    
    LogEntry.add_prepare(log_entry, signature: "temp_signature", node_id: node.id)
    
    assert Repo.all(assoc(log_entry, :commit_confirmations)) |> Enum.count == 1
  end
  
  test "when a log entry passes the quorum for commit confirmations it is marked as committed and executed" do
    node = %Node{url: "http://localhost-2", public_key: "abc"} |> Repo.insert
    {:ok, data} = %{ledger: %{hash: "123", publicKey: "abc", primaryAccountPublicKey: "cde"}}
                  |> Poison.encode
    {:ok, log_entry} = LogEntry.create command: "ledger/create", data: data
    LogEntry.add_prepare(log_entry, signature: "temp_signature", node_id: node.id)
    
    assert Repo.get(LogEntry, log_entry.id).committed == false

    LogEntry.add_commit(log_entry, signature: "temp_signature", node_id: node.id)
    
    assert Repo.get(LogEntry, log_entry.id).committed == true
  end
  
  test "executing log entry creates ledger with a primary account" do
    {:ok, data} = %{ledger: %{hash: "123", publicKey: "abc", primaryAccountPublicKey: "cde"}}
                  |> Poison.encode
    {:ok, log_entry} = LogEntry.create command: "ledger/create", data: data
    
    # LogEntry.execute(log_entry)
    
    assert Repo.all(LogEntry) |> Enum.count == 1
    assert Repo.all(Ledger)   |> Enum.count == 1
    assert Repo.all(Account)  |> Enum.count == 1
  end
  
  test "executing log entry creates account" do
    {:ok, data} = %{account: %{ledgerHash: "abc", publicKey: "cde"}}
                  |> Poison.encode
    {:ok, log_entry} = LogEntry.create command: "account/create", data: data
    
    # LogEntry.execute(log_entry)
    
    assert Repo.all(LogEntry) |> Enum.count == 1
    assert Repo.all(Account)  |> Enum.count == 1
  end
  
  test "executing log entry creates issue and changes primary wallet balances" do
    Ledger.create(hash: "123", public_key: "abc", primary_account_public_key: "cde")
    {:ok, data} = %{issue:
                    %{uuid: UUID.uuid4,
                      ledgerHash: "123",
                      amount: 100}}
                  |> Poison.encode
    
    {:ok, log_entry} = LogEntry.create command: "issue/create", data: data
    
    # LogEntry.execute(log_entry)
    
    assert Repo.all(LogEntry) |> Enum.count == 1
    assert Repo.all(Issue)    |> Enum.count == 1
    assert Repo.get(Account, "cde").balance == 100
  end
  
  test "executing log entry creates transfer and changes wallet balances" do
    Ledger.create(hash: "123", public_key: "abc", primary_account_public_key: "cde")
    Issue.create(uuid: UUID.uuid4, ledger_hash: "123", amount: 100)
    %Account{public_key: "def", ledger_hash: "123"} |> Repo.insert
    {:ok, data} = %{transfer:
                    %{uuid: UUID.uuid4,
                      amount: 100,
                      sourcePublicKey: "cde",
                      destinationPublicKey: "def"}}
                  |> Poison.encode
    
    {:ok, log_entry} = LogEntry.create command: "transfer/create", data: data
    # LogEntry.execute(log_entry)
    
    assert Repo.all(Transfer)    |> Enum.count == 1
    assert Repo.get(Account, "cde").balance == 0
    assert Repo.get(Account, "def").balance == 100
  end
end