defmodule Hyperledger.CommitConfirmation do
  use Ecto.Model
  
  alias Hyperledger.LogEntry
  alias Hyperledger.Node
  
  schema "commit_confirmations" do
    field :signature, :string

    timestamps
    
    belongs_to :log_entry, LogEntry
    belongs_to :node, Node
  end
end
