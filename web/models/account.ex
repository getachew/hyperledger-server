defmodule Hyperledger.Account do
  use Ecto.Model

  schema "accounts", primary_key: {:public_key, :string, []} do
    field :balance, :integer
    field :created_at, :datetime, default: Ecto.DateTime.local
    field :updated_at, :datetime, default: Ecto.DateTime.local
    
    belongs_to :ledger, Hyperledger.Ledger,
      foreign_key: :ledger_hash, type: :string
  end
end
