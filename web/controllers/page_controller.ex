defmodule Hyperledger.PageController do
  use Phoenix.Controller

  plug :action
  
  def index(conn, _params) do
    render conn, "index.json"
  end
  
end
