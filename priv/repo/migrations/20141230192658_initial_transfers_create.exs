defmodule Hyperledger.Repo.Migrations.InitialTransfersCreate do
  use Ecto.Migration

  def up do
    create table(:transfers, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :amount, :integer
      add :source_public_key, :string,
        references: :accounts, column: :public_key, type: :string
      add :destination_public_key, :string,
        references: :accounts, column: :public_key, type: :string
    
      timestamps
    end
  end

  def down do
    drop table(:transfers)
  end
end
