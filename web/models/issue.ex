defmodule Hyperledger.Issue do
  use Ecto.Model

  schema "issues", primary_key: {:uuid, :uuid, []} do
    field :amount, :integer
    field :created_at, :datetime, default: Ecto.DateTime.local
    field :updated_at, :datetime, default: Ecto.DateTime.local
    
    belongs_to :ledger, Hyperledger.Ledger,
      foreign_key: :ledger_hash, type: :string
  end
end
