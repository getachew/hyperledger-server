defmodule Hyperledger.PageView do
  use Hyperledger.Web, :view
    
  def render("index.uber", %{conn: conn}) do
    %{
      uber:
      %{
        version: "1.0",
        data:
        [
          %{
            rel: ["self"],
            url: page_url(conn, :index)
          },
          %{
            name: "ledgers",
            rel: ["collection"],
            url: ledger_url(conn, :index)
          }
        ]
      }
    }
  end
end
