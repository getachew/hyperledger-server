defmodule Hyperledger.Transfer do
  use Ecto.Model

  schema "transfers", primary_key: {:uuid, :uuid, []} do
    field :amount, :integer
    field :created_at, :datetime, default: Ecto.DateTime.local
    field :updated_at, :datetime, default: Ecto.DateTime.local
    
    belongs_to :source, Hyperledger.Account,
      foreign_key: :source_public_key, type: :string
    belongs_to :destination, Hyperledger.Account,
      foreign_key: :destination_public_key, type: :string
  end
end
