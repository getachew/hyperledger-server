defmodule Hyperledger.PageControllerTest do
  use Hyperledger.ConnCase
  
  test "GET the root path returns 200" do
    conn = get conn(), "/"
    assert conn.status == 200
  end
end