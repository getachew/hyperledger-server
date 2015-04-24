defmodule Hyperledger.TransferControllerTest do
  use Hyperledger.ConnCase
  
  alias Hyperledger.Transfer
  alias Hyperledger.LogEntry

  setup do
    create_primary
    {:ok, ledger} = create_ledger
    account = build(ledger, :accounts)
    %{ account | public_key: "fgh" } |> Repo.insert
    :ok
  end

  test "GET transfers" do
    conn = get conn(), "/transfers"
    assert conn.status == 200
  end
  
  test "POST transfers creates log entry and a transfer" do
    uuid = Ecto.UUID.generate
    body = %{transfer: %{uuid: uuid, sourcePublicKey: "def", destinationPublicKey: "fgh", amount: 100}}
    conn = post conn(), "/transfers", body
    
    assert conn.status == 201
    assert Repo.all(Transfer) |> Enum.count == 1
    assert Repo.all(LogEntry) |> Enum.count == 1
  end
end
