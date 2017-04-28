# Got this design pattern idea from: http://blog.danielberkompas.com/elixir/2015/07/16/fixtures-for-ecto.html

defmodule TelnyxOmegaPricing.Fixtures.FetchMonthlyPricesResponse do

  # For cornvenience I'm going to use one large fixture to accomodate all cases, but an argument could be made that
  # it would be cleaner and more self-documenting to break down the fixtures into many case-by-case sets of
  # data. Refactoring can be done to tailor smaller, more case-specific data fixtures later.

  def fixture(:omega_api_response_as_json) do
    Poison.encode(fixture(:omega_api_response_as_list)) |> elem(1)
  end

  def fixture(:omega_api_response_as_list) do
    [
      %{id: 123456,name: "Nice Chair",price: "$30.25",category: "home-furnishings",discontinued: false},
      %{id: 234567,name: "Black & White TV",price: "$43.77",category: "electronics",discontinued: true},  # gets ignored
      %{id: 1111,name: "An Existing Product",price: "$50.12",category: "electronics",discontinued: false},
      %{id: 1112,name: "A Now-Discontinued Product",price: "$6.23",category: "toys",discontinued: true},
      %{id: 3333,name: "A Product With a New Name",price: "$6.66",category: "lingerie",discontinued: true}, # error
    ]
  end

end