defmodule Hyperledger.AccountControllerTest do
  use HyperledgerTest.Case
  import Plug.Test
  alias Hyperledger.Router

  setup do
    ledger = %Hyperledger.Ledger{public_key: "123", hash: "abc"}
    Hyperledger.Repo.insert(ledger)
    :ok
  end

  test "get ledger accounts" do
    conn = conn(:get, "/ledgers/abc/accounts", headers: [{"content-type", "application/json"}])
    conn = Router.call(conn, [])
    assert conn.status == 200
  end
end
