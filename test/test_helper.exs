ExUnit.start

Mix.Task.run "ecto.drop", ["Hyperledger.Repo"]
Mix.Task.run "ecto.create", ["Hyperledger.Repo"]
Mix.Task.run "ecto.migrate", ["Hyperledger.Repo"]

defmodule HyperledgerTest.Case do
  use ExUnit.CaseTemplate
  use Plug.Test
  
  alias Ecto.Adapters.Postgres

  setup do
    Postgres.begin_test_transaction(Hyperledger.Repo)
    on_exit fn ->
      Postgres.rollback_test_transaction(Hyperledger.Repo)
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
