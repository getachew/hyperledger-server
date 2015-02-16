defmodule Hyperledger.LogEntry do
  use Ecto.Model
  
  alias Hyperledger.Repo
  alias Hyperledger.LogEntry
  alias Hyperledger.Ledger
  alias Hyperledger.Account
  alias Hyperledger.Issue
  alias Hyperledger.Transfer
  alias Hyperledger.Node
  alias Hyperledger.PrepareConfirmation
  alias Hyperledger.CommitConfirmation

  schema "log_entries" do
    field :view, :integer
    field :command, :string
    field :data, :string
    field :prepared, :boolean, default: false
    field :committed, :boolean, default: false
    field :executed, :boolean, default: false

    timestamps
      
    has_many :prepare_confirmations, PrepareConfirmation
    has_many :commit_confirmations, CommitConfirmation
  end
  
  def create(command: command, data: data) do
    Repo.transaction fn ->
      id = (Repo.all(LogEntry) |> Enum.count) + 1

      log_entry = %LogEntry{id: id, view: 1, command: command, data: data}
      log_entry = Repo.insert(log_entry)        
      add_prepare log_entry, signature: "temp_signature", node_id: Node.self_id
      log_entry
    end
  end
  
  def insert(id: id, view: view, command: command, data: data) do
    Repo.transaction fn ->
      if Node.self_id != 1 do
        log_entry = %LogEntry{id: id, view: view, command: command, data: data}
        log_entry = Repo.insert(log_entry)
        add_prepare log_entry, signature: "temp_signature", node_id: Node.self_id
        log_entry
      else
        Repo.rollback(:error)
      end
    end
  end
  
  def add_prepare(log_entry, signature: signature, node_id: node_id) do
    Repo.transaction fn ->
      prep_conf = build(log_entry, :prepare_confirmations)
      %{ prep_conf | signature: signature, node_id: node_id }
      |> Repo.insert
      
      prep_conf_count = Repo.all(assoc(log_entry, :prepare_confirmations))
                        |> Enum.count
            
      if (prep_conf_count >= Node.quorum and !log_entry.prepared) do
        %{ log_entry | prepared: true}
        |> Repo.update
        
        add_commit(log_entry, signature: "temp_signature", node_id: Node.self_id)
      end
    end
  end
  
  def add_commit(log_entry, signature: signature, node_id: node_id) do
    Repo.transaction fn ->
      commit_conf = build(log_entry, :commit_confirmations)
      %{ commit_conf | signature: signature, node_id: node_id }
      |> Repo.insert
      
      commit_conf_count = Repo.all(assoc(log_entry, :commit_confirmations))
                          |> Enum.count
            
      if (commit_conf_count >= Node.quorum and !log_entry.committed) do
        %{ log_entry | committed: true}
        |> Repo.update
        
        # If previous log entry has been executed then execute
        prev_log_entry = Repo.get(LogEntry, log_entry.id - 1)
        if is_nil(prev_log_entry) or prev_log_entry.executed do
          execute(log_entry)
        end
      end
    end
  end
  
  def execute(log_entry) do
    {:ok, params} = Poison.decode(log_entry.data)
    case log_entry.command do
      
      "ledger/create" ->
        %{"ledger" => %{
          "hash" => hash,
          "publicKey" => public_key,
          "primaryAccountPublicKey" => acc_public_key
        }} = params
        
        Ledger.create(hash: hash, public_key: public_key,
          primary_account_public_key: acc_public_key)
      
      "account/create" ->
        %{"account" => %{
          "ledgerHash" => hash,
          "publicKey" => public_key
        }} = params
      
        %Account{ledger_hash: hash, public_key: public_key}
        |> Repo.insert
        
      "issue/create" ->
        %{"issue" => %{
          "uuid" => uuid,
          "ledgerHash" => hash,
          "amount" => amount
        }} = params
      
        Issue.create(uuid: uuid, ledger_hash: hash, amount: amount)
        
      "transfer/create" ->
        %{"transfer" => %{
          "uuid" => uuid,
          "amount" => amount,
          "sourcePublicKey" => source_public_key,
          "destinationPublicKey" => destination_public_key
        }} = params
      
        Transfer.create(
          uuid: uuid,
          amount: amount,
          source_public_key: source_public_key,
          destination_public_key: destination_public_key)
    end
    
    # Mark as executed and check if there's a follow entry to execute
    # %{ log_entry | executed: true } |> Repo.insert
    next_entry = Repo.get(LogEntry, log_entry.id + 1)
    unless is_nil(next_entry) do
      execute(next_entry)
    end
  end
  
  
end
