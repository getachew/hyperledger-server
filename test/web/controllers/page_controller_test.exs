defmodule Hyperledger.PageControllerTest do
  use HyperledgerTest.Case
  
  test "GET the root path returns 200" do
    conn = call(:get, "/")
    assert conn.status == 200
  end
end