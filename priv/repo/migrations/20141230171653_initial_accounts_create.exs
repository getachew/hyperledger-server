defmodule Hyperledger.Repo.Migrations.InitialAccountsCreate do
  use Ecto.Migration

  def up do    
    create table(:accounts, primary_key: false) do
      add :public_key, :string, primary_key: true
      add :ledger_hash, :string,
        references: :ledgers, column: :hash, type: :string
      add :balance, :integer

      timestamps
    end
  end

  def down do
    drop table(:accounts)
  end
end
