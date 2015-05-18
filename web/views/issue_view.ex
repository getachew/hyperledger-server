defmodule Hyperledger.IssueView do
  use Hyperledger.Web, :view
  
  def render("index.uber", %{conn: conn, issues: issues, ledger: ledger}) do
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
              issue_body(issue, ["item"])
            end)
          }
        ]
      }
    }
  end
  
  def render("show.uber", %{issue: issue}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          issue_body(issue, ["self"])
        ]
      }
    }
  end
  
  defp issue_body(issue, rels) do
    %{
      name: "issue",
      rel: rels,
      data: [
        %{
          name: "uuid",
          value: issue.uuid
        },
        %{
          name: "amount",
          value: issue.amount
        }
      ]
    }
  end
end
