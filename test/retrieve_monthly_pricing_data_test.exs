defmodule RetrieveMonthlyPricingDataTest do
  use ExUnit.Case, async: false
  import TelnyxOmegaPricing.Fixtures.FetchMonthlyPricesResponse
  import OmegaClient.FetchMonthlyPrices.Mock
  import Utilities

  describe "OmegaClient.RetrieveMonthlyPricingData.call" do

    test "makes the correct DB changes" do
      # TODO make assertions of database records
      assert RetrieveMonthlyPricingData.call ==
             TelnyxOmegaPricing.Fixtures.FetchMonthlyPricesResponse.fixture(:omega_api_response_as_list)
    end

  end


end