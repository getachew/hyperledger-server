defmodule Hyperledger.LedgerControllerTest do
  use HyperledgerTest.Case
  import Plug.Test
  alias Hyperledger.Router
  
  test "get ledgers" do
    conn = conn(:get, "/ledgers", headers: [{"content-type", "application/json"}])
    conn = Router.call(conn, [])
    assert conn.status == 200
  end
    
end
