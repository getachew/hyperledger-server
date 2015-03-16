defmodule Hyperledger.LogEntryControllerTest do
  use HyperledgerTest.Case
    
  alias Hyperledger.Router
  alias Hyperledger.Repo
  alias Hyperledger.LogEntry
  
  setup do
    primary = create_node(1)
    System.put_env("NODE_URL", primary.url)
    :ok
  end
  
  test "list log" do
    conn = call(Router, :get, "/log")
    assert conn.status == 200
  end
  
  test "refuse to create new log when primary" do
    conn = call(Router, :post, "/log", log_entry_body,
      headers: [{"content-type", "application/json"}])

    assert conn.status == 403
    assert Repo.all(LogEntry) == []
  end
  
  test "accept log when replica" do
    node = create_node(2)
    System.put_env("NODE_URL", node.url)
    
    conn = call(Router, :post, "/log", log_entry_body,
      headers: [{"content-type", "application/json"}])

    assert conn.status == 201
    assert Repo.all(LogEntry) |> Enum.count == 1
  end

  defp log_entry_body(id \\ 1, view \\ 1) do
    data = %{ledger:
              %{hash: "123", publicKey: "abc", primaryAccountPublicKey: "def"}}
           |> Poison.encode!
    %{logEntry: %{id: id, view: view, command: "ledger/create", data: data},
      prepareConfirmations: [%{nodeId: 1, signautre: "abc"}],
      commitConfirmations: []}
  end
    
end
