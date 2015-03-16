defmodule Hyperledger.ModelTest.Node do
  use HyperledgerTest.Case
  use Ecto.Model
  
  alias Hyperledger.Repo
  alias Hyperledger.Node
      
  test "create" do
    Node.create(1, "http://localhost", "abcd")
    assert Repo.all(Node) |> Enum.count == 1
  end
  
  test "self returns the current node" do
    node = create_node(1)
    System.put_env("NODE_URL", node.url)
    assert Node.self == node
  end
  
  test "self raises error if env not set" do
    assert_raise RuntimeError, "NODE_URL env not set", fn ->
      Node.self
    end
  end
  
  test "self raises error if no node matches env" do
    assert_raise RuntimeError, "no node matches NODE_URL env", fn ->
      System.put_env "NODE_URL", "http://foo.com"
      Node.self
    end
  end
  
  test "quorum returns just over 2/3rds of all nodes" do
    node = create_node(1)
    System.put_env("NODE_URL", node.url)

    assert Node.quorum == 1
    
    create_node(2)
    create_node(3)
    assert Node.quorum == 3
    
    create_node(4)
    assert Node.quorum == 3
  end
end