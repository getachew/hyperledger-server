defmodule Hyperledger.Issue do
  use Ecto.Model

  alias Hyperledger.Repo
  alias Hyperledger.Ledger
  
  @primary_key {:uuid, Ecto.UUID, []}
  schema "issues" do
    field :amount, :integer

    timestamps
    
    belongs_to :ledger, Ledger,
      foreign_key: :ledger_hash,
      references: :hash,
      type: :string
    
    has_one :account, through: [:ledger, :primary_account]
  end
  
  @required_fields ~w(uuid amount ledger_hash)
  @optional_fields ~w()

  def changeset(transfer, params \\ nil) do
    transfer
    |> cast(params, @required_fields, @optional_fields)
  end
  
  def create(changeset) do
    Repo.transaction fn ->
      issue = Repo.insert(changeset)
      issue = Repo.preload(issue, [:ledger, :account])

      %{ issue.account | balance: (issue.account.balance + issue.amount)}
      |> Repo.update
      
      issue
    end
  end
  
end
