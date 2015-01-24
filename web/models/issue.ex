defmodule Hyperledger.Issue do
  use Ecto.Model

  alias Hyperledger.Repo
  alias Hyperledger.Issue
  alias Hyperledger.Ledger
  
  @primary_key {:uuid, :uuid, []}
  schema "issues" do
    field :amount, :integer

    timestamps
    
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
