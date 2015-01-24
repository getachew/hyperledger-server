defmodule Hyperledger.Node do
  use Ecto.Model
  
  import Ecto.Query, only: [from: 2]
  
  alias Hyperledger.Repo
  alias Hyperledger.Node
  alias Hyperledger.PrepareConfirmation
  
  schema "nodes" do
    field :url, :string
    field :public_key, :string

    timestamps
    
    has_many :prepare_confirmations, PrepareConfirmation
  end
  
  def self_id do
    [node] = Repo.all(from n in Node, where: n.url == ^System.get_env["NODE_URL"], select: n)
    node.id
  end
end
