ExUnit.start

Mix.Task.run "ecto.drop", ["Hyperledger.Repo"]
Mix.Task.run "ecto.create", ["Hyperledger.Repo"]
Mix.Task.run "ecto.migrate", ["Hyperledger.Repo"]

defmodule HyperledgerTest.Case do
  use ExUnit.CaseTemplate
  use Plug.Test
  
  alias Ecto.Adapters.SQL
  alias Hyperledger.Repo
  alias Hyperledger.Node

  setup do
    SQL.begin_test_transaction(Repo)
    on_exit fn ->
      SQL.rollback_test_transaction(Repo)
      System.delete_env("NODE_URL")
    end
  end

  using do
    quote do
      import HyperledgerTest.Case
    end
  end
  
  def call(router, verb, path, params \\ nil, headers \\ []) do
    conn = conn(verb, path, params, headers) |> Plug.Conn.fetch_params
    router.call(conn, router.init([]))
  end
  
  def create_node(n) do
    Node.create n, "http://localhost-#{n}", "#{n}"
  end
  
  def create_primary do
    primary = create_node(1)
    System.put_env("NODE_URL", primary.url)
  end
end
