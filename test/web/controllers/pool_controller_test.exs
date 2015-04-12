defmodule Hyperledger.PoolControllerTest do
  use Hyperledger.ConnCase

  setup do
    create_primary
    create_node(2)
    :ok
  end

  test "GET pool" do
    conn = get conn(), "/pool"
    assert conn.status == 200
  end
end
