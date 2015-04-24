defmodule Hyperledger.Account do
  use Ecto.Model
  
  alias Hyperledger.Repo
  
  @primary_key {:public_key, :string, []}
  schema "accounts" do
    field :balance, :integer, default: 0

    timestamps
    
    belongs_to :ledger, Hyperledger.Ledger,
      foreign_key: :ledger_hash, type: :string
  end
  
  @required_fields ~w(public_key ledger_hash)
  @optional_fields ~w()

  def changeset(account, params \\ nil) do
    account
    |> cast(params, @required_fields, @optional_fields)
  end
  
  def create(changeset) do
    Repo.insert(changeset)
  end
    
end
