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
              ledger_body(ledger, ["item"], conn)
            end)
          }
        ]
      }
    }
  end
  
  def render("show.uber", %{conn: conn, ledger: ledger}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          ledger_body(ledger, ["self"], conn)
        ]
      }
    }
  end
  
  defp ledger_body(ledger, rels, conn) do
    %{
      name: "ledger",
      rel: rels,
      data: [
        %{
          name: "hash",
          value: ledger.hash
        },
        %{
          name: "publicKey",
          value: ledger.public_key
        },
        %{
          name: "primaryAccount",
          url: account_url(conn, :show, ledger.primary_account_public_key)
        },
        %{
          name: "issues",
          rel: ["collection"],
          url: ledger_issue_url(conn, :index, ledger.hash)
        }
      ]
    }
  end
end
