defmodule TelnyxOmegaPricing.Fixtures.PastPrices do

  def fixture(:existing_data) do
    fixture(:existing_data_as_maps) |> Enum.map(fn(map) -> struct(TelnyxOmegaPricing.PastPrice, map) end)
  end

  def fixture(:existing_data_as_maps) do
    [
      %{id: 1, product_id: 1, price: 1000, percentage_change: nil},
      %{id: 2, product_id: 2, price: 2000, percentage_change: nil},
      %{id: 3, product_id: 3, price: 4000, percentage_change: nil},
    ]
  end

end