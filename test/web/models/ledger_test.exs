defmodule Hyperledger.LedgerModelTest do
  use Hyperledger.ModelCase
  
  alias Hyperledger.Ledger
  alias Hyperledger.Account
  
  setup do
    hash = :crypto.hash(:sha256, "123")
    {pk, _sk} = :crypto.generate_key(:ecdh, :secp256k1)
    {pa_pk, _sk} = :crypto.generate_key(:ecdh, :secp256k1)
    
    params =
      %{
        hash: Base.encode32(hash),
        public_key: Base.encode32(pk),
        primary_account_public_key: Base.encode32(pa_pk)
      }
    {:ok, params: params}
  end
  
  test "`changeset` checks encoding of fields", %{params: params} do
    bad_enc_cs =
      Ledger.changeset(
        %Ledger{},
        %{
          hash: Base.encode32(:crypto.rand_bytes(31)),
          public_key: "00",
          primary_account_public_key: "foo bar"}
      )
    
    assert Enum.count(bad_enc_cs.errors) == 2
    
    cs = Ledger.changeset(%Ledger{}, params)
    
    assert cs.valid? == true
  end
  
  test "`create` inserts a changeset into the db", %{params: params} do
    cs = Ledger.changeset(%Ledger{}, params)
    Ledger.create(cs)
    
    assert Repo.get(Ledger, params[:hash]) != nil
  end
  
  test "`create` also creates an associated primary account", %{params: params} do
    cs = Ledger.changeset(%Ledger{}, params)
    Ledger.create(cs)
    
    assert Repo.get(Account, params[:primary_account_public_key]) != nil
  end
  
  test "`create` returns the ledger", %{params: params} do
    cs = Ledger.changeset(%Ledger{}, params)
    assert {:ok, %Ledger{}} = Ledger.create(cs)
  end
end