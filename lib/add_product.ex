defmodule AddProduct do
  import Ecto.Query
  alias TelnyxOmegaPricing.{PastPrice, Product, Repo}

  # TODO use a guard clause for these parameters
  def call(external_product_id, product_name, price) do
    price_as_cents = Utilities.convert_price_string_to_cents(price)

    new_product = create_product(external_product_id, product_name, price_as_cents)
    create_past_price(new_product.id, price_as_cents)
  end

  # TODO DRY this - repeated from UpdateProductPrice
  defp create_past_price(product_id, new_price) do
    %PastPrice{product_id: product_id, price: new_price, percentage_change: nil}
    |> Repo.insert!
  end

  defp create_product(external_product_id, product_name, price) do
    %Product{external_product_id: external_product_id, product_name: product_name, price: price}
    |> Repo.insert!
  end

end