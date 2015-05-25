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
        hash: Base.encode16(hash),
        public_key: Base.encode16(pk),
        primary_account_public_key: Base.encode16(pa_pk)
      }
    {:ok, params: params}
  end
  
  test "`changeset` checks encoding of fields", %{params: params} do
    bad_enc_cs =
      Ledger.changeset(
        %Ledger{},
        %{
          hash: "GJ9D68b3RCw2HgjzEhtH+TjMcaiYTNntB4W8xa8FhA=="),
          public_key: "00",
          primary_account_public_key: "foo bar"}
      )
    
    assert Enum.count(bad_enc_cs.errors) == 2
    
    cs = Ledger.changeset(%Ledger{}, params)
    
    assert cs.valid? == true
  end
  
  test "`create` inserts a changeset into the db", %{params: params} do
    Ledger.changeset(%Ledger{}, params)
    |> Ledger.create
    
    assert Repo.get(Ledger, params.hash) != nil
  end
  
  test "`create` also creates an associated primary account", %{params: params} do
    {:ok, ledger} = Ledger.changeset(%Ledger{}, params)
                    |> Ledger.create
    
    primary_acc =
      Account
      |> Repo.get(params.primary_account_public_key)
      |> Repo.preload(:ledger)
    
    assert primary_acc != nil
    assert primary_acc.ledger == ledger
  end
  
  test "`create` returns the ledger", %{params: params} do
    cs = Ledger.changeset(%Ledger{}, params)
    assert {:ok, %Ledger{}} = Ledger.create(cs)
  end
end