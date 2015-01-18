defmodule :"Elixir.Hyperledger.Repo.Migrations.InitalNodeCreate.exs" do
  use Ecto.Migration

  def up do
    "CREATE TABLE nodes(
      id serial primary key, \
      url varchar(255), \
      public_key text, \
      created_at timestamp, \
      updated_at timestamp)"
  end

  def down do
    "DROP TABLE nodes"
  end
end
