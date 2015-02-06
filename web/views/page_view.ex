defmodule Hyperledger.PageView do
  use Hyperledger.View
  
  def render("index.json", _params) do
    %{
      uber:
      %{
        version: "1.0",
        data:
        [
          %{
            rel: ["self"],
            url: System.get_env("NODE_URL")
          },
          %{
            name: "ledgers",
            rel: ["collection"],
            # url: Hyperledger.Router.Helper.ledger_path(@conn)
          },
          %{
            name: "search",
            rel: ["search","collection"],
            url: "http://example.org/search",
            model: "{?title}"
          }
        ]
      }
    }
  end
end
