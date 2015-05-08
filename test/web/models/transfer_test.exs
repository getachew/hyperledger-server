defmodule Hyperledger.ModelTest.Transfer do
  use Hyperledger.ModelCase
  
  alias Hyperledger.Account
  alias Hyperledger.Transfer
  alias Hyperledger.Issue
  
  setup do
    {:ok, ledger} = create_ledger
    {d_pk, _sk} = :crypto.generate_key(:ecdh, :secp256k1)    
    dest_key = Base.encode32(d_pk)
    
    destination =
      %Account{}
      |> Account.changeset(%{public_key: dest_key, ledger_hash: ledger.hash})
      |> Account.create
    
    %Issue{}
    |> Issue.changeset(%{uuid: Ecto.UUID.generate, ledger_hash: ledger.hash, amount: 100})
    |> Issue.create
    
    params =
      %{
        uuid: Ecto.UUID.generate,
        source_public_key: ledger.primary_account_public_key,
        destination_public_key: destination.public_key,
        amount: 100
      }
    {:ok, params: params}
  end

  test "`changeset` validates that the amount is greater than zero", %{params: params} do
    cs = Transfer.changeset(%Transfer{}, Map.merge(params, %{amount: 0}))
    
    assert cs.valid? == false
  end
  
  test "`changeset` validates that the source account exists", %{params: params} do
    cs = Transfer.changeset(%Transfer{}, Map.merge(params, %{source_public_key: "AA"}))
    
    assert cs.valid? == false
  end
  
  test "`changeset` validates that the destination account exists", %{params: params} do
    cs = Transfer.changeset(%Transfer{}, Map.merge(params, %{destination_public_key: "AA"}))
    
    assert cs.valid? == false
  end
  
  test "`changeset` validates that the accounts' ledger is the same", %{params: params} do
    {:ok, alt_ledger} = create_ledger("456")
    params = Map.merge(params, %{source_public_key: alt_ledger.primary_account_public_key})
    cs = Transfer.changeset(%Transfer{}, params)
    
    assert cs.valid? == false
  end
    
  test "`create` inserts a changeset into the db", %{params: params} do
    Transfer.changeset(%Transfer{}, params)
    |> Transfer.create
    
    assert Repo.get(Transfer, params.uuid) != nil
  end

  test "`create` modifies the balance of the source and dest wallet", %{params: params} do
    Transfer.changeset(%Transfer{}, params)
    |> Transfer.create

    s = Repo.get(Account, params.source_public_key)
    assert s.balance == 0

    d = Repo.get(Account, params.destination_public_key)
    assert d.balance == 100
  end
end