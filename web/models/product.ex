defmodule TelnyxOmegaPricing.Product do
  use TelnyxOmegaPricing.Web, :model
#  use Ecto.Schema
#  import Ecto.Changeset

  schema "products" do
    field :external_product_id, :integer
    field :price, :integer
    field :product_name, :string

    timestamps
  end

  # @required_fields ~w(external_product_id)
  # @optional_fields ~w()
  #
  # def changeset(product, params \\ :empty) do
  #   product
  #   |> cast(params, @required_fields, @optional_fields)
  #   |> unique_constraint(:external_product_id)
  # end
end