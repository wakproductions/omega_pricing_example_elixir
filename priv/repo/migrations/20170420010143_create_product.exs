defmodule TelnyxOmegaPricing.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :external_product_id, :integer, unique: true
      add :price, :integer
      add :product_name, :string

      timestamps()
    end

    create unique_index(:products, [:external_product_id], name: :unique_product_id)
  end

end