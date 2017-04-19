defmodule OmegaClient.FetchMonthlyPrices do
  @api_endpoint "https://omegapricinginc.com/pricing/records.json"

  use Timex

  def call do
    
  end

  def api_endpoint do
    @api_endpoint
  end

  defp params do
    %{
      yourapi_key:  "abc123key",  # TODO put this in a constants module
      start_date:   Timex.today |> Timex.shift(months: -1),
      end_date:     Timex.today,
    }
  end

end