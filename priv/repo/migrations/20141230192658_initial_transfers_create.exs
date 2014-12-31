defmodule Hyperledger.Repo.Migrations.InitialTransfersCreate do
  use Ecto.Migration

  def up do
    "CREATE TABLE transfers(
      uuid uuid primary key, \
      source_public_key varchar(255), \
      destination_public_key varchar(255), \
      amount integer, \
      created_at timestamp, \
      updated_at timestamp)"
  end

  def down do
    "DROP TABLE transfers"
  end
end
