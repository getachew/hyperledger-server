defmodule Hyperledger.Repo.Migrations.InitialIssuesCreate do
  use Ecto.Migration

  def up do
    create table(:issues, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :ledger_hash, :string,
        references: :ledgers, column: :hash, type: :string
      add :amount, :integer, default: 0

      timestamps
    end
  end

  def down do
    drop table(:issues)
  end
end
