defmodule Hyperledger.LogEntryModelTest do
  use Hyperledger.ModelCase
  
  import Mock
  
  alias Hyperledger.LogEntry
  alias Hyperledger.Ledger
  alias Hyperledger.Account
  alias Hyperledger.Issue
  alias Hyperledger.Transfer
  alias Hyperledger.PrepareConfirmation
  alias Hyperledger.CommitConfirmation
  
  setup do
    create_primary
    :ok
  end
  
  test "creating the first log entry sets the id and view to 1" do
    {:ok, log_entry} = LogEntry.create command: "ledger/create", data: sample_ledger_data
    
    assert log_entry.id   == 1
    assert log_entry.view == 1
  end
  
  test "creating a log entry also appends a prepare confirmation from self" do
    {:ok, log_entry} = LogEntry.create command: "ledger/create", data: sample_ledger_data
        
    assert Repo.all(assoc(log_entry, :prepare_confirmations)) |> Enum.count == 1
  end
  
  test "creating a log entry broadcasts a prepare to other nodes" do
    node = create_node(2)
    
    json_data = sample_ledger_data
    headers = ["Content-Type": "application/json"]
    body = %{logEntry: %{id: 1, view: 1, command: "ledger/create",
                         data: json_data},
             prepareConfirmations: [%{nodeId: 1, signature: "temp_signature"}],
             commitConfirmations: []}
           |> Poison.encode!
    with_mock HTTPotion,
    post: fn(_, _) -> %HTTPotion.Response{status_code: 201} end do
      LogEntry.create command: "ledger/create", data: json_data
      
      assert(called(HTTPotion.post("#{node.url}/log",
        headers: headers, body: body)))
    end
  end
  
  test "inserting a log entry broadcasts a prepare to other nodes" do
    inital_node_url = System.get_env("NODE_URL")
    node = create_node(2)
    System.put_env("NODE_URL", node.url)
    create_node(3)
    
    json_data = sample_ledger_data
    headers = ["Content-Type": "application/json"]
    body = %{logEntry: %{id: 1, view: 1, command: "ledger/create",
                         data: json_data},
             prepareConfirmations: [
               %{nodeId: 1, signature: "temp_signature"},
               %{nodeId: 2, signature: "temp_signature"}],
             commitConfirmations: []}
           |> Poison.encode!
           
    with_mock HTTPotion,
    post: fn(_, _) -> %HTTPotion.Response{status_code: 201} end do
      LogEntry.insert id: 1, view: 1, command: "ledger/create", data: json_data,
        prepare_confirmations: [%{node_id: 1, signature: "temp_signature"}],
        commit_confirmations: []
      
      assert(called(HTTPotion.post("#{inital_node_url}/log",
        headers: headers, body: body)))
    end
  end
  
  test "a log entry marked as prepared broadcasts a commit to other nodes" do
    node = create_node(2)
    
    json_data = sample_ledger_data
    headers = ["Content-Type": "application/json"]
    body = %{logEntry: %{id: 1, view: 1, command: "ledger/create",
                         data: json_data},
             prepareConfirmations: [
               %{nodeId: 1, signature: "temp_signature"},
               %{nodeId: 2, signature: "temp_signature"}],
             commitConfirmations: [
               %{nodeId: 1, signature: "temp_signature"}]}
           |> Poison.encode!
           
    with_mock HTTPotion,
    post: fn(_, _) -> %HTTPotion.Response{status_code: 201} end do
      LogEntry.create command: "ledger/create", data: json_data
      
      LogEntry.insert id: 1, view: 1, command: "ledger/create", data: json_data,
        prepare_confirmations: [%{node_id: 2, signature: "temp_signature"}],
        commit_confirmations: []
            
      assert(called(HTTPotion.post("#{node.url}/log",
        headers: headers, body: body)))
    end
  end
  
  test "commit confirmations are appended to the record and become marked as committed" do
    create_node(2)
    LogEntry.create command: "ledger/create", data: sample_ledger_data
    LogEntry.insert id: 1, view: 1, command: "ledger/create",
      data: sample_ledger_data, prepare_confirmations: [
        %{node_id: 2, signature: "temp_signature"}], commit_confirmations: []
    
    LogEntry.insert id: 1, view: 1, command: "ledger/create",
      data: sample_ledger_data, prepare_confirmations: [],
      commit_confirmations: [%{node_id: 2, signature: "temp_signature"}]

    assert Repo.all(CommitConfirmation) |> Enum.count == 2
    assert Repo.get(LogEntry, 1).committed
  end
  
  test "inserting a log entry returns error if primary has no existing record" do
    assert {:error, _} = LogEntry.insert id: 1, view: 1, command: "ledger/create",
      data: sample_ledger_data, prepare_confirmations: [], commit_confirmations: []
  end
  
  test "inserting a log entry returns ok if primary has record which matches" do
    LogEntry.create command: "ledger/create", data: sample_ledger_data
    assert {:ok, %LogEntry{}} = LogEntry.insert(
      id: 1, view: 1, command: "ledger/create", data: sample_ledger_data,
      prepare_confirmations: [%{node_id: 1, signature: "temp_signature"},
                              %{node_id: 2, signature: "temp_signature"}],
      commit_confirmations: [])
    assert Repo.all(PrepareConfirmation) |> Enum.count == 2
    assert Repo.get(LogEntry, 1).prepared == true
  end
    
  test "inserting a log entry returns ok if node is not primary" do
    node = create_node(2)
    System.put_env("NODE_URL", node.url)

    assert {:ok, %LogEntry{}} = LogEntry.insert(
      id: 1, view: 1, command: "ledger/create", data: sample_ledger_data,
      prepare_confirmations: [%{node_id: 1, signature: "temp_signature"}],
      commit_confirmations: [])
  end
  
  test "inserting a log entry saves the confirmations and appends its own" do
    node = create_node(2)
    System.put_env("NODE_URL", node.url)

    LogEntry.insert id: 1, view: 1, command: "ledger/create",
      data: sample_ledger_data, prepare_confirmations: [%{
        node_id: 1, signature: "temp_signature"}], commit_confirmations: []
    
    assert Repo.all(PrepareConfirmation) |> Enum.count == 2
    
    LogEntry.insert id: 1, view: 1, command: "ledger/create", data: sample_ledger_data,
      prepare_confirmations: [%{node_id: 1, signature: "temp_signature"}],
      commit_confirmations: [%{node_id: 1, signature: "temp_signature"}]
    
    assert Repo.all(CommitConfirmation) |> Enum.count == 2
  end
  
  test "when a log entry passes the quorum for prepare confirmations it is marked as prepared" do
    node = create_node(2)
    {:ok, log_entry} = LogEntry.create command: "ledger/create", data: sample_ledger_data
    
    assert log_entry.prepared == false
    
    LogEntry.add_prepare(log_entry, node.id, "temp_signature")
    
    assert Repo.get(LogEntry, log_entry.id).prepared == true
  end
  
  test "when a log entry is marked as prepared the node adds a commit confirmation" do
    node = create_node(2)
    {:ok, log_entry} = LogEntry.create command: "ledger/create", data: sample_ledger_data

    assert Repo.all(assoc(log_entry, :commit_confirmations)) == []
    
    LogEntry.add_prepare(log_entry, node.id, "temp_signature")
    
    assert Repo.all(assoc(log_entry, :commit_confirmations)) |> Enum.count == 1
  end
  
  test "when a log entry passes the quorum for commit confirmations it is marked as committed and executed" do
    node = create_node(2)
    {:ok, log_entry} = LogEntry.create command: "ledger/create", data: sample_ledger_data
    LogEntry.add_prepare(log_entry, node.id, "temp_signature")
    
    log_entry = Repo.get(LogEntry, log_entry.id)
    assert log_entry.committed == false

    LogEntry.add_commit(log_entry, node.id, "temp_signature")
    
    log_entry = Repo.get(LogEntry, log_entry.id)
    assert log_entry.prepared  == true
    assert log_entry.committed == true
    assert log_entry.executed  == true
  end
  
  test "log entries are executed in order" do
    node = create_node(2)
    data_1 = Poison.encode!(ledger_params("123"))
    data_2 = Poison.encode!(ledger_params("456"))
    {:ok, log_entry_1} = LogEntry.create command: "ledger/create", data: data_1
    {:ok, log_entry_2} = LogEntry.create command: "ledger/create", data: data_2
    LogEntry.add_prepare(log_entry_1, node.id, "temp_signature")
    LogEntry.add_prepare(log_entry_2, node.id, "temp_signature")
    LogEntry.add_commit(log_entry_2, node.id, "temp_signature")
    
    assert Repo.all(Ledger) |> Enum.count == 0

    LogEntry.add_commit(log_entry_1, node.id, "temp_signature")
    
    assert Repo.all(Ledger) |> Enum.count == 2
  end
  
  test "executing log entry creates ledger with a primary account" do
    LogEntry.create command: "ledger/create", data: sample_ledger_data
        
    assert Repo.all(Ledger)   |> Enum.count == 1
    assert Repo.all(Account)  |> Enum.count == 1
  end
  
  test "executing log entry creates account" do
    {:ok, ledger} = create_ledger
    {pk, _sk} = :crypto.generate_key(:ecdh, :secp256k1)
    data = %{account: %{ledgerHash: ledger.hash, publicKey: Base.encode32(pk)}}
           |> Poison.encode!
    LogEntry.create command: "account/create", data: data
        
    assert Repo.all(LogEntry) |> Enum.count == 1
    assert Repo.all(Account)  |> Enum.count == 2
  end
  
  test "executing log entry creates issue and changes primary wallet balances" do
    {:ok, ledger} = create_ledger
    data = %{issue:
             %{uuid: Ecto.UUID.generate,
               ledgerHash: ledger.hash,
               amount: 100}}
           |> Poison.encode!
    LogEntry.create command: "issue/create", data: data
        
    assert Repo.all(Issue)    |> Enum.count == 1
    assert Repo.get(Account, ledger.primary_account_public_key).balance == 100
  end
  
  test "executing log entry creates transfer and changes wallet balances" do
    {:ok, ledger} = create_ledger
    Issue.changeset(%Issue{}, %{uuid: Ecto.UUID.generate, ledger_hash: ledger.hash, amount: 100})
    |> Issue.create
    %Account{public_key: "ghi", ledger_hash: ledger.hash}
    |> Repo.insert
    data = %{transfer:
             %{uuid: Ecto.UUID.generate,
               amount: 100,
               sourcePublicKey: ledger.primary_account_public_key,
               destinationPublicKey: "ghi"}}
           |> Poison.encode!
    LogEntry.create command: "transfer/create", data: data
    
    assert Repo.all(Transfer) |> Enum.count == 1
    assert Repo.get(Account, ledger.primary_account_public_key).balance == 0
    assert Repo.get(Account, "ghi").balance == 100
  end
  
  defp sample_ledger_data do
    Poison.encode!(ledger_params)
  end
end