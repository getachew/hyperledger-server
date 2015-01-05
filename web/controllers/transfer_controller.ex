defmodule Hyperledger.TransferController do
  use Phoenix.Controller

  plug :action

  def create(conn, params) do
    %{"transfer" =>
      %{"amount" => amount,
        "uuid" => uuid,
        "sourcePublicKey" => source_public_key,
        "destinationPublicKey" => destination_public_key}
      } = params
    transfer = %Hyperledger.Transfer{
      amount: amount,
      uuid: uuid,
      source_public_key: source_public_key,
      destination_public_key: destination_public_key}
      |> Hyperledger.Repo.insert
    json conn, serialize(transfer, conn)
  end
  
  defp serialize(obj, conn) do
    obj
    |> Hyperledger.TransferSerializer.as_json(conn, %{})
    |> Poison.encode!
  end
end
