defmodule Hyperledger.AccountView do
  use Hyperledger.Web, :view
  
  def render("index.uber", %{conn: conn, accounts: accounts}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          %{
            rel: ["self"],
            url: account_url(conn, :index)
          },
          %{
            id: "accounts",
            rel: ["collection"],
            data: Enum.map(accounts, fn account ->
              account_body(account, "item", conn)
            end)
          }
        ]
      }
    }
  end
  
  def render("show.uber", %{conn: conn, account: account}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          account_body(account, ["self"], conn)
        ]
      }
    }
  end
  
  defp account_body(account, rels, conn) do
    %{
      name: "account",
      rel: rels,
      url: account_url(conn, :show, account.public_key),
      data: [
        %{
          name: "ledgerHash",
          value: account.ledger_hash
        },
        %{
          name: "publicKey",
          value: account.public_key
        }
      ]
    }
  end
end
