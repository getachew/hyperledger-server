defmodule Hyperledger.TransferControllerTest do
  use Hyperledger.ConnCase
  
  alias Hyperledger.Transfer
  alias Hyperledger.LogEntry

  setup do
    create_primary
    {:ok, ledger} = create_ledger
    account = build(ledger, :accounts)
    %{ account | public_key: "fgh" } |> Repo.insert
    {:ok, ledger: ledger}
  end

  test "GET transfers" do
    conn = get conn(), "/transfers"
    assert conn.status == 200
  end
  
  test "POST transfers creates log entry and a transfer", %{ledger: ledger} do
    uuid = Ecto.UUID.generate
    source = ledger.primary_account_public_key
    body = %{transfer: %{uuid: uuid, sourcePublicKey: source, destinationPublicKey: "fgh", amount: 100}}
    conn = conn()
      |> put_req_header("content-type", "application/json")
      |> post("/transfers", Poison.encode!(body))
    
    assert conn.status == 201
    assert Repo.all(Transfer) |> Enum.count == 1
    assert Repo.all(LogEntry) |> Enum.count == 1
  end
end
