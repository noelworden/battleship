defmodule Battleship.Repo.Migrations.CreatePlacements do
  use Ecto.Migration

  def change do
    create table(:placements) do
      add :ship, :string
      add :cell, :string
      add :hit, :boolean, default: false, null: false

      timestamps(type: :naive_datetime_usec)
    end

    create unique_index(:placements, [:cell])
  end
end
