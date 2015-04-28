defmodule Hyperledger.LedgerView do
  use Hyperledger.Web, :view
  
  def render("index.uber", %{conn: conn, ledgers: ledgers}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          %{
            rel: ["self"],
            url: ledger_url(conn, :index)
          },
          %{
            id: "ledgers",
            rel: ["collection"],
            data: Enum.map(ledgers, fn ledger ->
              %{
                name: "ledger",
                rel: ["item"],
                data: [
                  %{
                    name: "hash",
                    value: ledger.hash
                  },
                  %{
                    name: "publicKey",
                    value: ledger.public_key
                  }
                ]
              }
            end)
          }
        ]
      }
    }
  end
  
  def render("show.uber", %{ledger: ledger}) do
    %{
      uber: %{
        version: "1.0",
        data: %{
          ledger: %{
            hash: ledger.hash,
            publicKey: ledger.public_key
          }
        }
      }
    }
  end
  
end
