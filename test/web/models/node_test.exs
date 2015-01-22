defmodule Hyperledger.ModelTest.Node do
  use HyperledgerTest.Case
  use Ecto.Model
  
  alias Hyperledger.Repo
  alias Hyperledger.Node
  
  test "self_id returns the id for the current node" do
    System.put_env("NODE_URL", "http://localhost")
    node = %Node{url: "http://localhost", public_key: "abc"}
           |> Repo.insert
    assert Node.self_id == node.id
  end
end