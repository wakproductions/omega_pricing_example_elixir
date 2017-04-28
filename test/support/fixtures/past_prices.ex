defmodule TelnyxOmegaPricing.Fixtures.PastPrices do

  def fixture(:existing_data) do
    fixture(:existing_data_as_maps) |> Enum.map(fn(map) -> struct(Product, map) end)
  end

  def fixture(:existing_data_as_maps) do
    [
      
    ]
  end

end