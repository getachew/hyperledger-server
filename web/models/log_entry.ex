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

  schema "log_entries" do
    field :command, :string
    field :data, :string
    field :signature, :string
    field :prepared, :boolean, default: false
    field :confirmed, :boolean, default: false

    timestamps
      
    has_many :prepare_confirmations, PrepareConfirmation
  end
  
  def create(command: command, data: data) do
    Repo.transaction(fn -> 
      log_entry = %LogEntry{command: command, data: data}
      {:ok, params} = Poison.decode(data)
      
      case command do
        
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
      
      log_entry = Repo.insert(log_entry)
      
      prep_conf = build(log_entry, :prepare_confirmations)
      %{ prep_conf | signature: "temp_signature", node_id: Node.self_id }
      |> Repo.insert

      log_entry
    end)
  end
  
end
