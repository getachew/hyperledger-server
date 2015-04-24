defmodule Hyperledger.LedgerModelTest do
  use Hyperledger.ConnCase
  
  alias Hyperledger.Repo
  alias Hyperledger.Ledger
  alias Hyperledger.Account
  
  setup do
    params = 
      %{
        hash: "123",
        public_key: "abc",
        primary_account_public_key: "cde"
      }
    {:ok, params: params}
  end
  
  test "`create` inserts a changeset into the db", %{params: params} do
    cs = Ledger.changeset(%Ledger{}, params)
    Ledger.create(cs)
    
    assert Repo.get(Ledger, "123") != nil
  end
  
  test "`create` also creates an associated primary account", %{params: params} do
    cs = Ledger.changeset(%Ledger{}, params)
    Ledger.create(cs)
    
    assert Repo.get(Account, "cde") != nil
  end
  
  test "`create` returns the ledger", %{params: params} do
    cs = Ledger.changeset(%Ledger{}, params)
    assert {:ok, %Ledger{}} = Ledger.create(cs)
  end
end