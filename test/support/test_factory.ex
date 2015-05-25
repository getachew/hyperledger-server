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
  
  def ledger_params(hashable \\ "123", with_auth \\ false) do
    hash = :crypto.hash(:sha256, hashable)
    {pk, sk} = key_pair
    {pa_pk, _sk} = key_pair
    
    body = %{
      ledger: %{
        hash: Base.encode16(hash),
        publicKey: Base.encode16(pk),
        primaryAccountPublicKey: Base.encode16(pa_pk)
      }
    }
    
    if with_auth do
      sig = :crypto.sign(:ecdsa, :sha256, Poison.encode!(body), [sk, :secp256k1])
      %{
        auth: Base.encode16(pk),
        sig: Base.encode16(sig)
      } |> Map.merge body
    else
      body
    end
  end
  
  defp key_pair do
    :crypto.generate_key(:ecdh, :secp256k1)
  end
end