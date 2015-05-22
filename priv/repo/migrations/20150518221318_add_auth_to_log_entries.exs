defmodule Hyperledger.Repo.Migrations.AddAuthToLogEntries do
  use Ecto.Migration

  def change do
    alter table(:log_entries) do
      add :authentication_key, :string
      add :signature, :string
    end
  end
end
