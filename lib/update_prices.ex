defmodule UpdatePrices do
  import Ecto.Query
  alias TelnyxOmegaPricing.Product, as: Product
  alias TelnyxOmegaPricing.Repo, as: Repo

  def call(received_api_data) do
    received_api_data |> Enum.map(&update_item/1)
  end

  defp existing_product(external_product_id) do
    from(
      p in Product,
      where: p.external_product_id == ^external_product_id,
      select: %{
        id: p.id,
        external_product_id: p.external_product_id,
        product_name: p.product_name,
        price: p.price,
        limit: 1,
      }
    )
    |> Repo.all
    |> List.first
  end

  defp update_item(new_item_details) do
    existing_item_details = existing_product(new_item_details.id)

    new_item_details |> inspect |> IO.puts
    existing_item_details |> inspect |> IO.puts

    cond do
      # **3a. We have external_product_id, same name, price is different**
      existing_item_details != nil && existing_item_details.product_name == new_item_details.name ->
        AddNewPrice.(new_item_details)

      # **3b. We do not have external_product_id, product is not discontinued**
      existing_item_details == nil && new_item_details.discontinued == false ->
        AddProduct.(new_item_details)

      # **3c. We have external_product_id, different product name**
      existing_item_details != nil && existing_item_details.product_name != new_item_details.name ->
        ErrorLogger.("Mismatching product name for external ID #{new_item_details.id}, " <>
                     "Existing name: #{existing_item_details.product_name}, New Name: #{new_item_details.name}"
                    )
    end

  end

end