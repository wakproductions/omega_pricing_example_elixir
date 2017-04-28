defmodule TelnyxOmegaPricing.Fixtures.Products do
  

  def fixture(:existing_data) do
    fixture(:existing_data_as_maps) |> Enum.map(fn(map) -> struct(TelnyxOmegaPricing.Product, map) end)
  end

  def fixture(:existing_data_as_maps) do
    [
      %{external_product_id: 1111, product_name: "An Existing Product", price: 1000}, # requirement 3a
      %{external_product_id: 1112, product_name: "A Now-Discontinued Product", price: 2000}, # requirement 3a
      %{external_product_id: 3333, product_name: "Outdated Product Name", price: 4000}, # requirement 3c
    ]
  end

end