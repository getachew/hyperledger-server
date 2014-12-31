defmodule Hyperledger.Repo.Migrations.InitialLedgersCreate do
  use Ecto.Migration

  def up do
    "CREATE TABLE ledgers( \
      hash varchar(255) primary key, \
      public_key varchar(255), \
      primary_account_public_key varchar(255), \
      created_at timestamp, \
      updated_at timestamp)"
  end

  def down do
    "DROP TABLE ledgers"
  end
end
