defmodule Hyperledger.ModelCase do
  @moduledoc """
  This module defines the test case to be used by
  model tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Alias the data repository and import query/model functions
      alias Hyperledger.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      # Import factory functions
      import Hyperledger.TestFactory
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Hyperledger.Repo, [])
    end
    
    on_exit fn ->
      System.delete_env("NODE_URL")
    end
    
    :ok
  end
end