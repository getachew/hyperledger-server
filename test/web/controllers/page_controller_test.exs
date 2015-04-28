defmodule Hyperledger.PageControllerTest do
  use Hyperledger.ConnCase
  
  test "GET the root path returns 200 and is an UBER resource" do
    conn = get conn(), "/"
    assert conn.status == 200
    [content_type] = get_resp_header(conn, "content-type")
    assert content_type =~ "application/vnd.uber-amundsen+json"
  end
end