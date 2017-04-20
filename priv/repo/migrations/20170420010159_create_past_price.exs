defmodule TelnyxOmegaPricing.Repo.Migrations.CreatePastPrice do
  use Ecto.Migration

  def change do
    create table(:past_prices) do
      add :product_id, :integer
      add :price, :integer
      add :percentage_change, :float

      timestamps()
    end
  end
end
