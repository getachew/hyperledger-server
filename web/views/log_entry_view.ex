defmodule Hyperledger.LogEntryView do
  use Hyperledger.View
  
  def render("index.json", %{entries: entries}) do
    %{
      uber: %{
        version: "1.0",
        data: %{
          logEntries: (Enum.map entries, fn entry ->
            %{
              command: entry.command,
              data: entry.data,
              prepared: entry.prepared,
              committed: entry.committed,
              executed: entry.executed
            }
          end)
        }
      }
    }
  end
  
  def render("error.json", _attrs) do
    %{
      uber: %{
        version: "1.0",
        error: %{
          data: %{
            name: "Primary does not accept logs"
          }
        }
      }
    }
  end
  
  def render("show.json", %{entry: entry}) do
    %{
      uber: %{
        version: "1.0",
        data: %{
          logEntry: %{
            id: entry.id,
            view: entry.view,
            command: entry.command,
            data: entry.data,
            prepared: entry.prepared,
            committed: entry.committed,
            executed: entry.executed
          }
        }
      }
    }
  end
  
end
