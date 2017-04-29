defmodule Utilities do

  def convert_price_string_to_cents(money_string) do
    money_string |> String.replace("$", "") |> String.replace(".", "") |> String.to_integer
  end

  def list_of_maps_to_atom_keys(list) do
    Enum.map(list, fn(x) -> for {key, val} <- x, into: %{}, do: {String.to_atom(key), val} end)
  end
end