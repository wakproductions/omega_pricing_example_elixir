defmodule RetrieveMonthlyPricingDataTest do
  use ExUnit.Case, async: false
  import TelnyxOmegaPricing.Fixtures.FetchMonthlyPricesResponse
  import OmegaClient.FetchMonthlyPrices.Mock

  describe "OmegaClient.RetrieveMonthlyPricingData.call" do

    test "makes the correct DB changes" do
      # TODO make assertions
#      assert RetrieveMonthlyPricingData.call ==
#             TelnyxOmegaPricing.Fixtures.FetchMonthlyPricesResponse.fixture(:omega_api_json_response)
    end

  end


end