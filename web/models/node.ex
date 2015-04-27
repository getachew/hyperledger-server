defmodule Hyperledger.Node do
  use Ecto.Model
  
  import Ecto.Query, only: [from: 2]
  
  require Logger
  
  alias Hyperledger.Repo
  alias Hyperledger.Node
  alias Hyperledger.PrepareConfirmation
  alias Hyperledger.CommitConfirmation
  
  schema "nodes" do
    field :url, :string
    field :public_key, :string

    timestamps
    
    has_many :prepare_confirmations, PrepareConfirmation
    has_many :commit_confirmations, CommitConfirmation
  end
  
  def create(id, url, public_key) do
    Repo.insert %Node{id: id, url: url, public_key: public_key}
  end
  
  def current do
    query = from n in Node,
            where: n.url == ^System.get_env["NODE_URL"],
            select: n
    
    try do
      Repo.one!(query)
    rescue
      Ecto.CastError -> raise "NODE_URL env not set"
      Ecto.NoResultsError -> raise "no node matches NODE_URL env"
    end
    
  end
    
  def quorum do
    node_count = Repo.all(Node) |> Enum.count
    node_count - div(node_count - 1, 3)
  end
  
  def broadcast(id, data) do
    Repo.all(Node)
    |> Enum.reject(&(&1 == current))
    |> Enum.each fn node ->
         try do
           Logger.info "Posting log entry #{id} to #{node.url}"
           post_log(node.url, data)
         rescue
           _ -> Logger.info "Error posting to replica node @ #{node.url}"
         end
       end
  end
  
  def post_log(url, data) do
    HTTPotion.post "#{url}/log",
      headers: ["Content-Type": "application/json"],
      body: Poison.encode!(data)
  end
end
