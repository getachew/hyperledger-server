defmodule Hyperledger.IssueView do
  use Hyperledger.Web, :view
  
  def render("index.json", %{conn: conn, issues: issues, ledger: ledger}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          %{
            rel: ["self"],
            url: ledger_issue_url(conn, :index, ledger.hash)
          },
          %{
            id: "issues",
            rel: ["collection"],
            data: Enum.map(issues, fn issue ->
              %{
                name: "issue",
                rel: ["item"],
                data: [
                  %{
                    name: "amount",
                    value: issue.amount
                  }
                ]
              }
            end)
          }
        ]
      }
    }
  end
  
  def render("show.json", %{issue: issue}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          %{
            rel: ["self"],
            name: "issue",
            data: [
              %{
                name: "amount",
                value: issue.amount
              }
            ]
          }
        ]
      }
    }
  end
  
end
