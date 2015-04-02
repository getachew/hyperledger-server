defmodule Hyperledger.TransferView do
  use Hyperledger.Web, :view
  
  def render("index.json", %{conn: conn, transfers: transfers}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          %{
            rel: ["self"],
            url: transfer_url(conn, :index)
          },
          %{
            id: "transfers",
            rel: ["collection"],
            data: Enum.map(transfers, fn transfer ->
              %{
                name: "transfer",
                rel: ["item"],
                data: [
                  %{
                    name: "uuid",
                    value: transfer.uuid
                  },
                  %{
                    name: "sourcePublicKey",
                    value: transfer.source_public_key
                  },
                  %{
                    name: "destinationPublicKey",
                    value: transfer.destination_public_key
                  }
                ]
              }
            end)
          }
        ]
      }
    }
  end
  
  def render("show.json", %{conn: conn, transfer: transfer}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          %{
            rel: ["self"],
            name: "transfer",
            data: [
              %{
                name: "uuid",
                value: transfer.uuid
              },
              %{
                name: "sourcePublicKey",
                value: transfer.source_public_key
              },
              %{
                name: "destinationPublicKey",
                value: transfer.destination_public_key
              },
              %{
                name: "amount",
                value: transfer.amount
              }
            ]
          }
        ]
      }
    }
  end
  
end
