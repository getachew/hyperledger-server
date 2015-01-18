defmodule Hyperledger.Node do
  use Ecto.Model
  
  schema "nodes" do
    field :url, :string
    field :public_key, :string
    field :created_at, :datetime, default: Ecto.DateTime.local
    field :updated_at, :datetime, default: Ecto.DateTime.local
  end
  
end
