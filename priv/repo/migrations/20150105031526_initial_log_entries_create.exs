defmodule Hyperledger.Repo.Migrations.InitialLogEntriesCreate do
  use Ecto.Migration

  def up do
    "CREATE TABLE log_entries(
      id serial primary key, \
      command varchar(255), \
      data text, \
      signature text, \
      created_at timestamp, \
      updated_at timestamp)"
  end

  def down do
    "DROP TABLE log_entries"
  end
end
