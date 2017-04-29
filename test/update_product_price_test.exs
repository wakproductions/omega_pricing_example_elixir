defmodule UpdateProductPriceTest do
  use ExUnit.Case
  import UpdateProductPrice
  import TelnyxOmegaPricing.Fixtures.PastPrices
  import TelnyxOmegaPricing.Fixtures.Products

  alias TelnyxOmegaPricing.Fixtures, as: Fixtures
  alias TelnyxOmegaPricing.PastPrice, as: PastPrice
  alias TelnyxOmegaPricing.Product, as: Product
  alias TelnyxOmegaPricing.Repo, as: Repo

  describe "TelnyxOmegaClient.UpdatePrice.call" do

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

    # Mimics the data received by the JSON API
    # 
    # Original pricing detail:
    # PastPrice:  %{id: 1, product_id: 1, price: 1000, percentage_change: nil}
    # Product:    %{id: 1, external_product_id: 1111, product_name: "An Existing Product", price: 1000}
    #
    # Expected new pricing detail:
    # PastPrice:  %{id: <new autoincrement id>, product_id: 1, price: 1512, percentage_change: 40.12}
    # Product:    %{id: 1, external_product_id: 1111, product_name: "An Existing Product", price: 50_02}
    defp new_pricing_detail do
      %{product_id: 1, new_price: "$15.12"}
    end

    defp new_past_price_database_record do
      Repo.get_by(PastPrice, %{product_id: 1, price: 15_12, percentage_change: 51.2})
    end

    defp updated_product_database_record do
      Repo.get_by(Product, %{external_product_id: 1111, price: 15_12})
    end

    test "makes the correct DB changes" do
      UpdateProductPrice.call(new_pricing_detail)
      assert new_past_price_database_record() != nil
      assert updated_product_database_record() != nil
    end

  end


end