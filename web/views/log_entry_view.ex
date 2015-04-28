defmodule Hyperledger.LogEntryView do
  use Hyperledger.Web, :view
  
  def render("index.uber", %{entries: entries}) do
    %{
      uber: %{
        version: "1.0",
        data: %{
          logEntries: (Enum.map entries, fn entry ->
            Hyperledger.LogEntry.as_json(entry)
          end)
        }
      }
    }
  end
  
  def render("error.uber", _attrs) do
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
  
  def render("show.uber", %{entry: entry}) do
    %{
      uber: %{
        version: "1.0",
        data: Hyperledger.LogEntry.as_json(entry)
      }
    }
  end
  
end
