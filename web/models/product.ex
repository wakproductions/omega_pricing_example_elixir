defmodule TelnyxOmegaPricing.Product do
  use TelnyxOmegaPricing.Web, :model

  schema "products" do
    field :external_product_id, :integer
    field :price, :integer
    field :product_name, :string

    timestamps
  end

end