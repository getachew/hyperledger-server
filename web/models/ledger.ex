defmodule Hyperledger.Ledger do
  use Ecto.Model
  import Hyperledger.Validations

  alias Hyperledger.Repo
  alias Hyperledger.Account
  alias Hyperledger.Issue
  alias Hyperledger.Transfer
  
  @primary_key {:hash, :string, []}
  schema "ledgers" do
    field :public_key, :string
    
    timestamps
    
    has_many :accounts,  Account
    has_many :issues,    Issue
    has_many :transfers, Transfer
    
    belongs_to :primary_account, Account,
      foreign_key: :primary_account_public_key,
      references: :public_key,
      type: :string
  end
  
  @required_fields ~w(hash public_key primary_account_public_key)
  @optional_fields ~w()

  def changeset(ledger, params \\ nil) do
    ledger
    |> cast(params, @required_fields, @optional_fields)
    |> validate_encoding(:hash)
    |> validate_encoding(:public_key)
    |> validate_encoding(:primary_account_public_key)
  end
  
  def create(changeset) do
    Repo.transaction fn ->
      ledger = Repo.insert(changeset)
      
      account = build(ledger, :primary_account)
      %{ account | public_key: ledger.primary_account_public_key}
      |> Repo.insert
      
      ledger
    end
  end
end
