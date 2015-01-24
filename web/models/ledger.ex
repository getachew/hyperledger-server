defmodule Hyperledger.Ledger do
  use Ecto.Model

  alias Hyperledger.Repo
  alias Hyperledger.Ledger
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
  
  def create(attrs) do
    [hash: h, public_key: pk, primary_account_public_key: a_pk] = attrs
    Repo.transaction fn ->
      %Ledger{hash: h, public_key: pk, primary_account_public_key: a_pk}
      |> Repo.insert
      %Account{ledger_hash: h, public_key: a_pk} |> Repo.insert
    end
  end
  
end
