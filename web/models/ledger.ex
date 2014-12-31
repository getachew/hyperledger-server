defmodule Hyperledger.Ledger do
  use Ecto.Model

  schema "ledgers", primary_key: {:hash, :string, []} do
    field :public_key, :string
    field :created_at, :datetime, default: Ecto.DateTime.local
    field :updated_at, :datetime, default: Ecto.DateTime.local
    
    has_many :accounts, Hyperledger.Account
    has_many :issues,   Hyperledger.Issues
    belongs_to :primary_account, Hyperledger.Account,
      foreign_key: :primary_account_public_key, type: :string
  end
end
