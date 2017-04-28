defmodule TelnyxOmegaPricing.PastPrice do
  use TelnyxOmegaPricing.Web, :model

  schema "past_prices" do
    field :product_id,        :integer
    field :price,             :integer
    field :percentage_change, :float

    timestamps
  end

end