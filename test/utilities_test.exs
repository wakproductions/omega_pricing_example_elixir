defmodule UtilitiesTest do
  use ExUnit.Case, async: true

  describe "list_of_maps_to_atom_keys" do

    setup do
      [
        before: [%{"key1a"=>"value1", "key1b"=>"value2"},%{"key2a"=>"v1", "key2b"=>"v2"}],
        after:  [%{key1a: "value1", key1b: "value2"},%{key2a: "v1", key2b: "v2"}]
      ]
    end

    test "converts the map of string keys to atom keys", context do
      assert Utilities.list_of_maps_to_atom_keys(context[:before]) == context[:after]
    end

  end


end