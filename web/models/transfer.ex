defmodule Hyperledger.Transfer do
  use Ecto.Model

  alias Hyperledger.Repo
  alias Hyperledger.Transfer
  alias Hyperledger.Account
  
  schema "transfers", primary_key: {:uuid, :uuid, []} do
    field :amount, :integer
    field :created_at, :datetime, default: Ecto.DateTime.local
    field :updated_at, :datetime, default: Ecto.DateTime.local
    
    belongs_to :source, Account,
      foreign_key: :source_public_key,
      references: :public_key,
      type: :string
    belongs_to :destination, Account,
      foreign_key: :destination_public_key,
      references: :public_key,
      type: :string
  end
  
  def create(attrs) do
    Repo.transaction fn ->
      transfer = %Transfer{
        uuid: UUID.info(attrs[:uuid])[:binary],
        amount: attrs[:amount],
        source_public_key: attrs[:source_public_key],
        destination_public_key: attrs[:destination_public_key]
      }
        
      [source] = Repo.all assoc(transfer, :source)
      [destination] = Repo.all assoc(transfer, :destination)
      
      %{ source | balance: (source.balance - transfer.amount)}
      |> Repo.update
      %{ destination | balance: (destination.balance + transfer.amount)}
      |> Repo.update
      Repo.insert(transfer)
    end
  end
  
end
