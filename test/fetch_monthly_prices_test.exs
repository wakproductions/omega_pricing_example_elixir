defmodule FetchMonthlyPricesTest do
  use ExUnit.Case, async: false
  import TelnyxOmegaPricing.Fixtures.FetchMonthlyPricesResponse

  describe "OmegaClient.FetchMonthlyPrices.call" do

  test "makes the correct API call" do
    # Consider extracting the web request method so that the test is agnostic to the HTTP library used. For example see
    # https://hashrocket.com/blog/posts/mocking-requests-in-elixir-tests
#    HTTPoison.start
#    with_mock HTTPoison, [:unstick, :passthrough], [get: fn(_url) -> fixture(:omega_api_json_response) end] do
#      OmegaClient.FetchMonthlyPrices.call
#      assert called HTTPoison.get(OmegaClient.FetchMonthlyPrices.api_endpoint)
#    end
  end

  end


end