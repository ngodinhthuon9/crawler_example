defmodule Crawler do
  @doc """
    Fetch a list of all of the product of Apple Flagship Store from Shopee.
  """
  def get_products(url) do
    content = get_content_html(url)
    parse_products(content)
  end

  def parse_products(content) do
    if content == nil do
      []
    else
      content
      |> Floki.find("script")
      |> Floki.find("[data-rh=true]")
      |> Enum.map(&(Floki.children(&1) |> Floki.text()))
      |> Enum.map(&parse_product(&1))
      |> Enum.filter(&(&1 != nil))
    end
  end

  def parse_product(data) do
    data_map = Jason.decode!(data)

    if data_map["@type"] != "Product" do
      nil
    else
      offers = data_map["offers"]
      price = Map.get(offers, "price", "0.0")
      %ProductItem{
        name: data_map["name"],
        image: data_map["image"],
        price: parse_price(Map.get(offers, "price", price)),
        url: data_map["url"]
      }
    end
  end

  defp parse_price(price_as_str) do
    case Float.parse(price_as_str) do
      :error      -> 0
      {number, _} -> round(number)
    end
  end

  defp get_content_html(url) do
    case get_content_from_url(url) do
      {:ok, content} ->
        content
      _ -> nil
    end
  end

  defp get_content_from_url(url) do
    headers = []
    options = [recv_timeout: 10000]
    case HTTPoison.get(url, headers, options) do
      {:ok, response} ->
        case response.status_code do
          200 -> {:ok, response.body}
          _   -> :error
        end
      _ -> :error
    end
  end
end
