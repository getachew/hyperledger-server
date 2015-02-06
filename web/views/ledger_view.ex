defmodule Hyperledger.LedgerView do
  use Hyperledger.View
  
  def render("index.json", %{ledgers: ledgers}) do
    %{
      uber: %{
        version: "1.0",
        data: %{
          ledgers: (Enum.map ledgers, fn ledger ->
            %{
              hash: ledger.hash,
              publicKey: ledger.public_key
            }
          end)
        }
      }
    }
  end
  
  def render("show.json", %{ledger: ledger}) do
    %{
      uber: %{
        version: "1.0",
        data: %{
          ledger: %{
            hash: ledger.hash,
            publicKey: ledger.public_key
          }
        }
      }
    }
  end
  
end
