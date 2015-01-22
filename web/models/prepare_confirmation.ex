defmodule Hyperledger.PrepareConfirmation do
  use Ecto.Model
  
  alias Hyperledger.LogEntry
  alias Hyperledger.Node
  
  schema "prepare_confirmations" do
    field :signature, :string
    field :created_at, :datetime, default: Ecto.DateTime.local
    field :updated_at, :datetime, default: Ecto.DateTime.local

    belongs_to :log_entry, LogEntry
    belongs_to :node, Node
  end
end
