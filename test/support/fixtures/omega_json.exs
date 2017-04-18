# Got this design pattern idea from: http://blog.danielberkompas.com/elixir/2015/07/16/fixtures-for-ecto.html

defmodule MyApp.Fixtures.OmegaJSON do

  # For convenience I'm going to use one large fixture to accomodate all cases, but an argument could be made that
  # it would be cleaner and more self-documenting to break down the fixtures into many case-by-case sets of
  # data. For the purposes of this demo, I think a single large test fixture is fine - refactoring can be done
  # to break this down further later.

  def fixture(:omega_json) do
    Poison.encode(records) |> elem(1)
  end

  defp records do
    [
      %{id: 123456,name: "Nice Chair",price: "$30.25",category: "home-furnishings",discontinued: false},
      %{id: 234567,name: "Black & White TV",price: "$43.77",category: "electronics",discontinued: true},
    ]
  end
end