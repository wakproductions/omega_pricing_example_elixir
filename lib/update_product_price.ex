defmodule UpdateProductPrice do
  import Ecto.Query
  alias TelnyxOmegaPricing.{PastPrice, Product, Repo}

  # TODO product_detail right now is expected to be a map containing %{product_id: x, new_price: y}
  # TODO Can probably use a guard clause and changing the input to a keyword list. Still figuring out the
  # TODO best practice here. Also, better to use keyword list input than map inputs?
  def call(product_detail) do
    new_price = product_detail[:new_price] |> Utilities.convert_price_string_to_cents
    previous_price = previous_price(product_detail[:product_id])
    percentage_change = percentage_change(previous_price, new_price)

    update_product_price(product_detail[:product_id], new_price)
    create_past_price(product_detail[:product_id], new_price, percentage_change)
  end

  defp create_past_price(product_id, new_price, percentage_change) do
    %PastPrice{product_id: product_id, price: new_price, percentage_change: percentage_change}
    |> Repo.insert!
  end

  defp percentage_change(previous_price, new_price) do
    if previous_price == nil do
      nil
    else
      (new_price / previous_price - 1) * 100 |> Float.round(2)
    end
  end

  defp previous_price(product_id) do
    q = from p in PastPrice,
        limit: 1,
        order_by: [desc: p.inserted_at],
        where: p.product_id == ^product_id,
        select: %{id: p.id, product_id: p.product_id, price: p.price, percentage_change: p.percentage_change}

    r = Repo.all(q)

    if r == [] do
      nil
    else
      List.first(r)[:price]
    end
  end

  defp update_product_price(product_id, new_price) do
    Repo.get!(Product, product_id)
    |> Product.changeset(%{price: new_price})
    |> Repo.update!
  end

end