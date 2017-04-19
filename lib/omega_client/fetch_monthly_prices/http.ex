defmodule OmegaClient.FetchMonthlyPrices.HTTP do
  @api_endpoint "https://omegapricinginc.com/pricing/records.json"

  use Timex

  @doc """
    This version of FetchMonthlyPrices is supposed to perform the actual web request to the Omega Pricing API. However,
    we can't test it because the API doesn't exist in real life (it's just a hypothetical example), but if it were
    to exist my code would look something like this. Also, the data would have to be parsed out of the returned
    tuple and converted form JSON to a list/map.
  """
  def call do
    HTTPoison.get(api_endpoint(), params())
  end

  def api_endpoint, do: @api_endpoint

  # This is the params to be sent, per the specification. I tested the Timex calls in iex console, but
  # because we are using a mock to run the test suite, this code won't actually run in real life.
  defp params do
    %{
      yourapi_key:  "abc123key",  # TODO put this value in a constants module or pull from environment variables
      start_date:   to_string(Timex.today |> Timex.shift(months: -1)),
      end_date:     to_string(Timex.today),
    }
  end

end