defmodule Hyperledger.ModelTest.Account do
  use Hyperledger.ModelCase
  
  alias Hyperledger.Account
  
  setup do
    {:ok, ledger} = create_ledger
    {pk, _sk} = :crypto.generate_key(:ecdh, :secp256k1)
    {:ok, ledger: ledger, pk: Base.encode32(pk)}
  end
  
  test "`changeset` validates encoding of key", %{ledger: ledger} do
    cs = Account.changeset(%Account{}, %{ledger_hash: ledger.hash, public_key: "123"})

    assert cs.valid? == false
  end

  test "`changeset` validates presence of ledger", %{pk: pk} do
    cs = Account.changeset(%Account{}, %{ledger_hash: "123", public_key: pk})

    assert cs.valid? == false
  end

  test "`create` inserts a valid record with balance of 0", %{ledger: ledger, pk: pk} do
    Account.changeset(%Account{}, %{ledger_hash: ledger.hash, public_key: pk})
    |> Account.create

    assert Repo.get(Account, pk).balance == 0
  end
end