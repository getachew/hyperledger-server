defmodule Hyperledger.PageController do
  use Hyperledger.Web, :controller

  plug :action
  
  def index(conn, _params) do
    render conn, "index.json"
  end
  
end
