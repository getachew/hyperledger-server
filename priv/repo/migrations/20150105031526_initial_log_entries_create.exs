defmodule Hyperledger.Repo.Migrations.InitialLogEntriesCreate do
  use Ecto.Migration

  def up do
    create table(:log_entries) do
      add :view, :integer
      add :command, :string
      add :data, :string
      add :prepared, :boolean, default: false
      add :committed, :boolean, default: false
      add :executed, :boolean, default: false
      
      timestamps
    end
  end

  def down do
    drop table(:log_entries)
  end
end
