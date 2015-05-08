defmodule Hyperledger.Transfer do
  use Ecto.Model
  import Hyperledger.Validations
  
  alias Hyperledger.Repo
  alias Hyperledger.Account
  
  @primary_key {:uuid, Ecto.UUID, []}
  schema "transfers" do
    field :amount, :integer

    timestamps
    
    belongs_to :source, Account,
      foreign_key: :source_public_key,
      references: :public_key,
      type: :string
    belongs_to :destination, Account,
      foreign_key: :destination_public_key,
      references: :public_key,
      type: :string
  end
  
  @required_fields ~w(uuid amount source_public_key destination_public_key)
  @optional_fields ~w()

  def changeset(transfer, params \\ nil) do
    transfer
    |> cast(params, @required_fields, @optional_fields)
    |> validate_existence(:source_public_key, Account)
    |> validate_existence(:destination_public_key, Account)
    |> validate_ledger_equality
    |> validate_number(:amount, greater_than: 0)
  end
  
  def create(changeset) do
    Repo.transaction fn ->
      transfer = Repo.insert(changeset)
      transfer = Repo.preload(transfer, [:source, :destination])
      
      %{ transfer.source | balance: (transfer.source.balance - transfer.amount)}
      |> Repo.update
      %{ transfer.destination | balance: (transfer.destination.balance + transfer.amount)}
      |> Repo.update
      
      transfer
    end
  end
  
  defp validate_ledger_equality(changeset) do
    source = Repo.get(Account, changeset.changes.source_public_key)
    dest   = Repo.get(Account, changeset.changes.destination_public_key)
    
    cond do
      is_nil(source) or is_nil(dest) -> changeset
      source.ledger_hash == dest.ledger_hash -> changeset
      true -> add_error changeset, :accounts, :are_not_on_the_same_ledger
    end
    # validate_change changeset, nil, fn _,_ ->
    #   # unless is_nil(source) or is_nil(dest) do
    #     IO.puts "here"
    #   # else
    #   #   IO.puts "Nils"
    #   # end
    # end
  end
end
