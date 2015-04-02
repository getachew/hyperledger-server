defmodule Hyperledger.ModelTest.Transfer do
  use HyperledgerTest.Case
  
  alias Hyperledger.Repo
  alias Hyperledger.Account
  alias Hyperledger.Ledger
  alias Hyperledger.Transfer
  
  setup do
    Ledger.create(
      hash: "abc",
      public_key: "123",
      primary_account_public_key: "cde")
      
    %Account{public_key: "234", ledger_hash: "abc", balance: 100}
    |> Repo.insert
    %Account{public_key: "345", ledger_hash: "abc"}
    |> Repo.insert
    
    :ok
  end
  
  test "`create` inserts the record into the db" do
    uuid = Ecto.UUID.generate
    Transfer.create(
      uuid: uuid,
      source_public_key: "234",
      destination_public_key: "345",
      amount: 100)

    assert Repo.get(Transfer, uuid) != nil
  end

  test "`create` modifies the balance of the source and dest wallet" do
    Transfer.create(
      uuid: Ecto.UUID.generate,
      source_public_key: "234",
      destination_public_key: "345",
      amount: 100)

    s = Repo.get(Account, "234")
    assert s.balance == 0

    d = Repo.get(Account, "345")
    assert d.balance == 100
  end
end