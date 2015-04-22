defmodule Hyperledger.PoolController do
  use Hyperledger.Web, :controller
  
  alias Hyperledger.Node
  alias Hyperledger.Repo
  
  plug :action

  def index(conn, _params) do
    nodes = Repo.all(Node)
    render conn, :index, nodes: nodes
  end
end
