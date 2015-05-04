defmodule Hyperledger.TestFactory do
  import Hyperledger.ParamsHelpers, only: [underscore_keys: 1]

  alias Hyperledger.Node
  alias Hyperledger.Ledger
  
  def create_node(n) do
    Node.create n, "http://localhost-#{n}", "#{n}"
  end

  def create_primary do
    primary = create_node(1)
    System.put_env("NODE_URL", primary.url)
  end
  
  def create_ledger(hashable \\ "123") do
    params = underscore_keys(ledger_params(hashable))
    Ledger.changeset(%Ledger{}, params["ledger"])
    |> Ledger.create
  end
  
  def ledger_params(hashable \\ "123") do
    hash = :crypto.hash(:sha256, hashable)
    {pk, _sk} = :crypto.generate_key(:ecdh, :secp256k1)
    {pa_pk, _sk} = :crypto.generate_key(:ecdh, :secp256k1)
    
    %{
      ledger: %{
        hash: Base.encode32(hash),
        publicKey: Base.encode32(pk),
        primaryAccountPublicKey: Base.encode32(pa_pk)
      }
    }
  end
end