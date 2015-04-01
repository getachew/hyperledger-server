defmodule Hyperledger.PoolView do
  use Hyperledger.Web, :view
  
  def render("index.json", %{conn: conn, nodes: nodes}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          %{
            rel: ["self"],
            url: pool_url(conn, :index)
          },
          %{
            id: "nodes",
            rel: ["collection"],
            data: Enum.map(nodes, fn node ->
              %{
                name: "node",
                rel: ["item"],
                url: node.url,
                data: [
                  %{
                    name: "publicKey",
                    value: node.public_key
                  }
                ]
              }
            end)
          }
        ]
      }
    }
  end
end
