defmodule Hyperledger.Repo.Migrations.InitalPrepareConfirmationsCreate do
  use Ecto.Migration

  def up do
    "CREATE TABLE prepare_confirmations(
      id serial primary key, \
      signature varchar(255), \
      log_entry_id integer, \
      node_id integer, \
      created_at timestamp, \
      updated_at timestamp)"
  end

  def down do
    ""
  end
end
