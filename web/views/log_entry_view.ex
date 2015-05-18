defmodule Hyperledger.LogEntryView do
  use Hyperledger.Web, :view
  
  def render("index.uber", %{conn: conn, entries: entries}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          %{
            id: "logEntries",
            rel: ["self", "collection"],
            url: log_entry_url(conn, :index),
            data: Enum.map(entries, fn entry ->
              log_entry_body(entry, ["item"])
            end)
          }  
        ]
      }
    }
  end
  
  def render("show.uber", %{entry: entry}) do
    %{
      uber: %{
        version: "1.0",
        data: [
          log_entry_body(entry, ["item"])
        ]
      }
    }
  end
  
  def render("error.uber", _attrs) do
    %{
      uber: %{
        version: "1.0",
        error: %{
          data: [
            %{
              name: "unprocessable",
              value: "Primary does not accept logs"
            }
          ]
        }
      }
    }
  end
  
  defp log_entry_body(log_entry, rels) do
    log_entry = Hyperledger.Repo.preload(log_entry, [:prepare_confirmations, :commit_confirmations])
    %{
      name: "logEntry",
      rel: rels,
      data: [
        %{
          name: "id",
          value: log_entry.id
        },
        %{
          name: "view",
          value: log_entry.view
        },
        %{
          name: "command",
          value: log_entry.command
        },
        %{
          name: "data",
          value: log_entry.data
        },
        %{
          name: "prepareConfirmations",
          rel: ["collection"],
          data: [
            Enum.map(log_entry.prepare_confirmations, fn conf ->
              confirmation_body(conf, "prepareConfirmation")
            end)
          ]
        },
        %{
          name: "prepareConfirmations",
          rel: ["collection"],
          data: [
            Enum.map(log_entry.commit_confirmations, fn conf ->
              confirmation_body(conf, "commitConfirmation")
            end)
          ]
        }    
      ]
    }
  end
  
  defp confirmation_body(conf, name) do
    %{
      name: name,
      data: [
        %{
          name: "node",
          value: conf.node_id
        },
        %{
          name: "signature",
          value: conf.signature
        }
      ]
    }
  end
end
