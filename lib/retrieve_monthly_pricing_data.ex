defmodule RetrieveMonthlyPricingData do
  import Utilities

  @fetch_monthly_prices_api Application.get_env(:telnyx_omega_pricing, :omega_pricing_api)

  def call do
    # TODO make some code to handle Poison errors. Assuming it will be :ok response
    @fetch_monthly_prices_api.call
    |> Poison.decode
    |> elem(1)
    |> list_of_maps_to_atom_keys



    # Perform update of the database

  end

end