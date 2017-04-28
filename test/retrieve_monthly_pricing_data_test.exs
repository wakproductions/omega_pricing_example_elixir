require IEx

defmodule RetrieveMonthlyPricingDataTest do
  use ExUnit.Case
  import TelnyxOmegaPricing.Fixtures.Products

  alias TelnyxOmegaPricing.Fixtures, as: Fixtures
  alias TelnyxOmegaPricing.Product, as: Product
  alias TelnyxOmegaPricing.Repo, as: Repo

  describe "OmegaClient.RetrieveMonthlyPricingData.call" do

    setup do
      # Need these Sandbox lines here due to a problem with Phoenix
      # https://github.com/elixir-ecto/ecto/issues/1319
      Ecto.Adapters.SQL.Sandbox.checkout(Repo)
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

      for x <- Fixtures.Products.fixture(:existing_data) do
        Repo.insert!(x)
      end

      :ok
    end

    defp expected_database_records do
      [
        %{external_product_id: 1111, product_name: "An Existing Product", price: 5012}, # requirement 3a
        %{external_product_id: 1112, product_name: "A Now-Discontinued Product", price: 6023}, # 3a

        # processing for this one raises an error, but we don't change anything
        %{external_product_id: 3333, product_name: "Outdated Product Name", price: 4000},

        %{external_product_id: 123456, product_name: "Nice Chair", price: 3025}, #3b
      ]
    end

    defp updated_database_records do
      Repo.all(Product)
      |> Enum.map(fn(p) ->
          p
          |> Map.from_struct
          |> Map.take([:external_product_id, :price, :product_name])
         end)
    end

    test "makes the correct DB changes" do
      RetrieveMonthlyPricingData.call
      assert updated_database_records() == expected_database_records()
    end

  end


end