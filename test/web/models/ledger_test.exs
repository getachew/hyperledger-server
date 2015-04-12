defmodule Hyperledger.LedgerModelTest do
  use Hyperledger.ConnCase
  
  alias Hyperledger.Repo
  alias Hyperledger.Ledger
  alias Hyperledger.Account
  
  test "`create` inserts the record into the db" do
    Ledger.create(
      hash: "123",
      public_key: "abc",
      primary_account_public_key: "cde")
    
    assert Repo.get(Ledger, "123") != nil
  end
  
  test "`create` also creates an associated primary account" do
    Ledger.create(
      hash: "123",
      public_key: "abc",
      primary_account_public_key: "cde")
    
    assert Repo.get(Account, "cde") != nil
  end
  
  test "`create` returns the ledger" do
    assert {:ok, %Ledger{}} = Ledger.create(
                                hash: "123",
                                public_key: "abc",
                                primary_account_public_key: "cde")
  end
end