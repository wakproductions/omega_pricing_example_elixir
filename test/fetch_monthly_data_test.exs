defmodule FetchMonthlyDataTest do
  use ExUnit.Case, async: false
  import TelnyxOmegaPricing.Fixtures.FetchMonthlyPricesResponse

  import Mock

  # TODO change this to the actual mock
  test "makes the correct API call" do
#    with_mock HTTPoison, [get: fn(_url) -> fixture(:omega_api_json_response) end] do
    with_mock HTTPoison, [get: fn(_url) -> "result" end] do
      HTTPoison.get("http://example.com")
      # Tests that make the expected call
      assert called HTTPoison.get("http://example.com")
    end
  end

end