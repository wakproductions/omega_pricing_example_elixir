require IEx

defmodule RetrieveMonthlyPricingDataTest do
  use ExUnit.Case
  import TelnyxOmegaPricing.Fixtures.PastPrices
  import TelnyxOmegaPricing.Fixtures.Products

  alias TelnyxOmegaPricing.Fixtures, as: Fixtures
  alias TelnyxOmegaPricing.PastPrice, as: PastPrice
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

      for x <- Fixtures.PastPrices.fixture(:existing_data) do
        Repo.insert!(x)
      end

      :ok
    end

    defp expected_past_price_database_records do
      [
        %{product_id: 1, price: 1000, percentage_change: nil},
        %{product_id: 2, price: 2000, percentage_change: nil},
        %{product_id: 3, price: 4000, percentage_change: nil},
        %{product_id: 1, price: 5012, percentage_change: 401.2},
        %{product_id: 2, price: 623, percentage_change: -68.85},
        %{product_id: 4, price: 3025, percentage_change: nil},
      ]
    end

    defp expected_product_database_records do
      [
        %{external_product_id: 1111, product_name: "An Existing Product", price: 5012}, # requirement 3a
        %{external_product_id: 1112, product_name: "A Now-Discontinued Product", price: 623}, # 3a

        # processing for this one raises an error, but we don't change anything
        %{external_product_id: 3333, product_name: "Outdated Product Name", price: 4000},

        %{external_product_id: 123456, product_name: "Nice Chair", price: 3025}, #3b
      ]
    end

    def updated_past_price_database_records do
      Repo.all(PastPrice)
      |> Enum.map(fn(p) ->
        p
        |> Map.from_struct
        |> Map.take([:product_id, :price, :percentage_change])
        end)
    end

    defp updated_product_database_records do
      Repo.all(Product)
      |> Enum.map(fn(p) ->
        p
        |> Map.from_struct
        |> Map.take([:external_product_id, :price, :product_name])
        end)
    end

    test "makes the correct DB changes" do
      RetrieveMonthlyPricingData.call
      assert updated_product_database_records() == expected_product_database_records()
      assert updated_past_price_database_records() == expected_past_price_database_records()

      # TODO need a test to make certain ErrorLogger is called for case 3c
    end

  end


end