defmodule Hyperledger.PageView do
  use Hyperledger.Web, :view
    
  def render("index.uber", %{conn: conn}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          %{
            rel: ["self"],
            name: "subledger",
            url: page_url(conn, :index)
          },
          %{
            id: "poolConfig",
            url: pool_url(conn, :index)
          },
          %{
            id: "log",
            rel: ["collection"],
            url: log_entry_url(conn, :index)
          },
          %{
            id: "ledgers",
            rel: ["collection"],
            url: ledger_url(conn, :index),
            data: [
              %{
                name: "create",
                url: ledger_url(conn, :create),
                accepting: "application/json",
                action: "append"
              }
            ]
          },
          %{
            id: "accounts",
            rel: ["collection"],
            url: account_url(conn, :index),
            data: [
              %{
                name: "create",
                url: account_url(conn, :create),
                accepting: "application/json",
                action: "append"
              }
            ]
          },
          %{
            id: "transfers",
            rel: ["collection"],
            url: transfer_url(conn, :index),
            data: [
              %{
                name: "create",
                url: transfer_url(conn, :create),
                accepting: "application/json",
                action: "append"
              }
            ]
          }  
        ]
      }
    }
  end
end
