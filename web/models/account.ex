defmodule Hyperledger.Account do
  use Ecto.Model
  
  @primary_key {:public_key, :string, []}
  schema "accounts" do
    field :balance, :integer, default: 0

    timestamps
    
    belongs_to :ledger, Hyperledger.Ledger,
      foreign_key: :ledger_hash, type: :string
  end
end
