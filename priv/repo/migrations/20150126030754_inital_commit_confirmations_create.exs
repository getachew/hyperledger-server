defmodule Hyperledger.Repo.Migrations.InitalCommitConfirmationsCreate do
  use Ecto.Migration

  def up do
    create table(:commit_confirmations) do
      add :signature, :string
      add :log_entry_id, :integer, references: :log_entries
      add :node_id, :integer, references: :nodes

      timestamps
    end
  end

  def down do
  end
end
