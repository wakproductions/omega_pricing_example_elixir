defmodule RetrieveMonthlyPricingData do
  @fetch_monthly_prices_api Application.get_env(:telnyx_omega_pricing, :omega_pricing_api)

  def call do
    # Make the web request
    @fetch_monthly_prices_api.call

    # Parse the JSON response into a map

    # Perform update of the database

  end

end