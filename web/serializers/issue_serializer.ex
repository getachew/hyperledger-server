defmodule Hyperledger.IssueSerializer do
  use Relax.Serializer

  serialize "issues" do
    attributes [:amount, :ledger_hash]
  end
end