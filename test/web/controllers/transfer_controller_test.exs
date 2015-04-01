defmodule Hyperledger.TransferControllerTest do
  use HyperledgerTest.Case
  use Ecto.Model
  
  alias Hyperledger.Transfer
  alias Hyperledger.Ledger
  alias Hyperledger.LogEntry
  alias Hyperledger.Repo

  setup do
    create_primary
    {:ok, ledger} = Ledger.create hash: "123", public_key: "abc", primary_account_public_key: "def"
    account = build(ledger, :accounts)
    %{ account | public_key: "fgh" } |> Repo.insert
    :ok
  end

  test "GET transfers" do
    conn = call(:get, "/transfers", [{"content-type", "application/json"}])
    assert conn.status == 200
  end
  
  test "POST transfers creates log entry and a transfer" do
    uuid = UUID.uuid4
    body = %{transfer: %{uuid: uuid, sourcePublicKey: "def", destinationPublicKey: "fgh", amount: 100}}
    conn = call(:post, "/transfers", body, [{"content-type", "application/json"}])
    
    assert conn.status == 201
    assert Repo.all(Transfer) |> Enum.count == 1
    assert Repo.all(LogEntry) |> Enum.count == 1
  end
end
