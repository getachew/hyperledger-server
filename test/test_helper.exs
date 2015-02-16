ExUnit.start

Mix.Task.run "ecto.drop", ["Hyperledger.Repo"]
Mix.Task.run "ecto.create", ["Hyperledger.Repo"]
Mix.Task.run "ecto.migrate", ["Hyperledger.Repo"]

defmodule HyperledgerTest.Case do
  use ExUnit.CaseTemplate
  use Plug.Test
  
  alias Ecto.Adapters.SQL
  alias Hyperledger.Repo

  setup do
    SQL.begin_test_transaction(Repo)
    on_exit fn ->
      SQL.rollback_test_transaction(Repo)
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

end
