defmodule Hyperledger.TransferView do
  use Hyperledger.Web, :view
  
  def render("index.uber", %{conn: conn, transfers: transfers}) do
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
              transfer_body(transfer, ["item"])
            end)
          }
        ]
      }
    }
  end
  
  def render("show.uber", %{transfer: transfer}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          transfer_body(transfer, ["self"])
        ]
      }
    }
  end
  
  defp transfer_body(transfer, rels) do
    %{
      name: "transfer",
      rel: rels,
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
  end
end
