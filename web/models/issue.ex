defmodule Hyperledger.Issue do
  use Ecto.Model

  alias Hyperledger.Repo
  alias Hyperledger.Issue
  alias Hyperledger.Ledger
  alias Hyperledger.Account
  
  @primary_key {:uuid, :uuid, []}
  schema "issues" do
    field :amount, :integer
    field :created_at, :datetime, default: Ecto.DateTime.local
    field :updated_at, :datetime, default: Ecto.DateTime.local
    
    belongs_to :ledger, Ledger,
      foreign_key: :ledger_hash, type: :string
  end
  
  def create(attrs) do
    Repo.transaction fn ->
      ledger = Repo.get(Ledger, attrs[:ledger_hash])
      [account] = Repo.all assoc(ledger, :primary_account)

      %{account | balance: (account.balance + attrs[:amount])}
      |> Repo.update
      %Issue{
        uuid: UUID.info(attrs[:uuid])[:binary],
        ledger_hash: attrs[:ledger_hash],
        amount: attrs[:amount]}
      |> Repo.insert
    end
  end
  
end
