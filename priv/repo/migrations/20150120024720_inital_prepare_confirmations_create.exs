defmodule Hyperledger.Repo.Migrations.InitalPrepareConfirmationsCreate do
  use Ecto.Migration

  def up do
    create table(:prepare_confirmations) do
      add :signature, :string
      add :log_entry_id, :integer, references: :log_entries
      add :node_id, :integer, references: :nodes

      timestamps
    end
  end

  def down do
    drop table(:prepare_confirmations)
  end
end
