defmodule Hyperledger.LedgerSerializer do
  use Relax.Serializer

  serialize "ledgers" do
    attributes [:hash, :public_key]
  end
end