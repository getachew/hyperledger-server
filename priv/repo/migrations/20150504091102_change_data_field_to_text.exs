defmodule Hyperledger.Repo.Migrations.ChangeDataFieldToText do
  use Ecto.Migration

  def up do
    alter table(:log_entries) do
      modify :data, :text
    end
  end
  
  def down do
    alter table(:log_entries) do
      modify :data, :string
    end
  end
  
end
