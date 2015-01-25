defmodule Hyperledger.ModelTest.Node do
  use HyperledgerTest.Case
  use Ecto.Model
  
  alias Hyperledger.Repo
  alias Hyperledger.Node
    
  test "self_id returns the id for the current node" do
    node = add_node(1)
    System.put_env("NODE_URL", node.url)
    assert Node.self_id == node.id
  end
  
  test "quorum returns just over 2/3rds of all nodes" do
    node = add_node(1)
    System.put_env("NODE_URL", node.url)

    assert Node.quorum == 1
    
    add_node(2)
    add_node(3)
    assert Node.quorum == 3
    
    add_node(4)
    assert Node.quorum == 3
  end
  
  defp add_node(n) do
    %Node{url: "http://localhost-#{n}", public_key: "#{n}"}
    |> Repo.insert
  end
  
end