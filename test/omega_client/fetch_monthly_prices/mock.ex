defmodule OmegaClient.FetchMonthlyPrices.Mock do
  import TelnyxOmegaPricing.Fixtures.FetchMonthlyPricesResponse

  @doc """
    This is the mock version of FetchMonthlyPrices to be used for testing. I am unclear a this time on whether Elixir
    encourages mock versions of the system like this to reside along with the rest of the code or in a special
    test support folder.
  """
  def call do
    TelnyxOmegaPricing.Fixtures.FetchMonthlyPricesResponse.fixture(:omega_api_json_response)
  end

end