defmodule Hyperledger.Repo.Migrations.InitialLedgersCreate do
  use Ecto.Migration

  def up do
    create table(:ledgers, primary_key: false) do
      add :hash, :string, primary_key: true
      add :public_key, :string
      add :primary_account_public_key, :string
      
      timestamps
    end
  end

  def down do
    drop table(:ledgers)
  end
end
