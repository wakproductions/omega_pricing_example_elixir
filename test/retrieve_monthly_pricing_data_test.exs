require IEx

defmodule RetrieveMonthlyPricingDataTest do
  use ExUnit.Case
  import Ecto.Query
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
        %{product_id: new_product_id, price: 3025, percentage_change: nil},
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

    defp find_record(record_set, attrs) do
      record_set
      |> Enum.find(fn(x)-> x == attrs end)
    end

    # This is kind of a hacky solution to getting the product_id of the newly added product
    defp new_product_id do
      from(r in Product, select: r.id, order_by: [desc: r.id], limit: 1) |> Repo.all |> List.first
    end

    defp past_price_records_count do
      from(r in PastPrice, select: count(r.id)) |> Repo.all |> List.first
    end

    defp product_records_count do
      from(r in Product, select: count(r.id)) |> Repo.all |> List.first
    end

    defp updated_past_price_database_records do
      from(r in PastPrice, order_by: r.id)
      |> Repo.all
      |> Enum.map(fn(p) ->
        p
        |> Map.from_struct
        |> Map.take([:product_id, :price, :percentage_change])
        end)
    end

    defp updated_product_database_records do
      from(r in Product, order_by: r.id)
      |> Repo.all
      |> Enum.map(fn(p) ->
        p
        |> Map.from_struct
        |> Map.take([:external_product_id, :price, :product_name])
        end)
    end

    test "makes the correct DB changes" do
      RetrieveMonthlyPricingData.call

      assert past_price_records_count() == expected_past_price_database_records() |> length
      assert product_records_count() == expected_product_database_records() |> length

      past_price_records = updated_past_price_database_records()
      expected_past_price_database_records()
      |> Enum.map(fn(r) ->
        assert find_record(past_price_records, r) != nil, "Couldn't find expected records #{inspect(r)}"
      end)

      product_records = updated_product_database_records()
      expected_product_database_records()
      |> Enum.map(fn(r) ->
        assert find_record(product_records, r) != nil, "Couldn't find expected records #{inspect(r)}"
      end)

      # TODO need a test to make certain ErrorLogger is called for case 3c - maybe create a mock module?
    end

  end


end