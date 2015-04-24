defmodule Hyperledger.Transfer do
  use Ecto.Model

  alias Hyperledger.Repo
  alias Hyperledger.Transfer
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
  
end
