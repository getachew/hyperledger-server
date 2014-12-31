defmodule Hyperledger.Repo.Migrations.InitialIssuesCreate do
  use Ecto.Migration

  def up do
    "CREATE TABLE issues(
      uuid uuid primary key, \
      ledger_hash varchar(255), \
      amount integer, \
      created_at timestamp, \
      updated_at timestamp)"
  end

  def down do
    "DROP TABLE issues"
  end
end
