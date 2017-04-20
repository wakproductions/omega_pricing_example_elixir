defmodule Utilities do

  def list_of_maps_to_atom_keys(list) do
    Enum.map(list, fn(x) -> for {key, val} <- x, into: %{}, do: {String.to_atom(key), val} end)
  end

end