defmodule TelnyxOmegaPricing.Product do
  use TelnyxOmegaPricing.Web, :model

  schema "products" do
    field :external_product_id, :integer
    field :price, :integer
    field :product_name, :string

    timestamps
  end

    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:external_product_id, :price, :product_name])
    end

end