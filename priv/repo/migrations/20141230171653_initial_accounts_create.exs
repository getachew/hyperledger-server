defmodule Hyperledger.Repo.Migrations.InitialAccountsCreate do
  use Ecto.Migration

  def up do    
    "CREATE TABLE accounts(
      public_key varchar(255) primary key, \
      ledger_hash varchar(255), \
      balance integer, \
      created_at timestamp, \
      updated_at timestamp)"
  end

  def down do
    "DROP TABLE accounts"
  end
end
