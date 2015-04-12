defmodule Hyperledger.LogEntryControllerTest do
  use Hyperledger.ConnCase
    
  alias Hyperledger.LogEntry
  
  setup do
    create_primary
    :ok
  end
  
  test "list log" do
    conn = get conn(), "/log"
    assert conn.status == 200
  end
  
  test "refuse to create new log when primary" do
    conn = post conn(), "/log", log_entry_body

    assert conn.status == 403
    assert Repo.all(LogEntry) == []
  end
  
  test "accept log when replica" do
    node = create_node(2)
    System.put_env("NODE_URL", node.url)
    
    conn = post conn(), "/log", log_entry_body

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
