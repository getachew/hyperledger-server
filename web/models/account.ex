defmodule Hyperledger.Account do
  use Ecto.Model
  import Hyperledger.Validations
  
  alias Hyperledger.Repo
  alias Hyperledger.Ledger
  
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
    |> validate_encoding(:public_key)
    |> validate_existence(:ledger_hash, Ledger)
  end
  
  def create(changeset) do
    Repo.insert(changeset)
  end
end
