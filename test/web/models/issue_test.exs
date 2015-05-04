defmodule Hyperledger.ModelTest.Issue do
  use Hyperledger.ModelCase

  alias Hyperledger.Issue
  alias Hyperledger.Ledger
  
  setup do
    {:ok, ledger} = create_ledger
    params =
      %{
        uuid: Ecto.UUID.generate,
        ledger_hash: ledger.hash,
        amount: 100
      }
    {:ok, params: params}
  end
  
  test "`create` inserts a changeset into the db", %{params: params} do
    cs = Issue.changeset(%Issue{}, params)
    Issue.create(cs)

    assert Repo.get(Issue, params[:uuid]) != nil
  end

  test "`create` also modifies the balance of the primary wallet", %{params: params} do
    cs = Issue.changeset(%Issue{}, params)
    Issue.create(cs)

    l = Repo.get(Ledger, params[:ledger_hash])
    a = Repo.one(assoc(l, :primary_account))
    assert a.balance == 100
  end
end