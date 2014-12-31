defmodule Hyperledger.AccountSerializer do
  use Relax.Serializer

  serialize "accounts" do
    attributes [:public_key, :balance, :ledger_hash]
  end
end