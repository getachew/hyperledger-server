defmodule Hyperledger.PoolControllerTest do
  use HyperledgerTest.Case

  setup do
    create_primary
    create_node(2)
    :ok
  end

  test "GET pool" do
    conn = call(:get, "/pool", [{"content-type", "application/json"}])
    assert conn.status == 200
  end
end
