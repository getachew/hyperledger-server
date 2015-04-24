defmodule Hyperledger.ModelTest.Transfer do
  use Hyperledger.ConnCase
  
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
    
    params =
      %{transfer:
        %{uuid: Ecto.UUID.generate,
          source_public_key: "234",
          destination_public_key: "345",
          amount: 100
        }
      }
    {:ok, params: params}
  end
    
  test "`create` inserts a changeset into the db", %{params: params} do
    cs = Transfer.changeset %Transfer{}, params[:transfer]
    Transfer.create cs
    assert Repo.get(Transfer, params[:transfer][:uuid]) != nil
  end

  test "`create` modifies the balance of the source and dest wallet", %{params: params} do
    cs = Transfer.changeset %Transfer{}, params[:transfer]
    Transfer.create(cs)

    s = Repo.get(Account, "234")
    assert s.balance == 0

    d = Repo.get(Account, "345")
    assert d.balance == 100
  end
end