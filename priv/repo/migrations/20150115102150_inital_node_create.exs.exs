defmodule :"Elixir.Hyperledger.Repo.Migrations.InitalNodeCreate.exs" do
  use Ecto.Migration

  def up do
    create table(:nodes) do
      add :url, :string
      add :public_key, :string

      timestamps
    end
  end

  def down do
    drop table(:nodes)
  end
end
