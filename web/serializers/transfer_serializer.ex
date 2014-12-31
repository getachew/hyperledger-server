defmodule Hyperledger.TransferSerializer do
  use Relax.Serializer

  serialize "transfers" do
    attributes [:amount, :uuid, :source_public_key, :destination_public_key]
  end
end