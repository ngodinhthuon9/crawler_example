defmodule CrawlerExampleWeb.PageController do
  use CrawlerExampleWeb, :controller

  def index(conn, _params) do
    url = "https://shopee.vn/apple_flagship_store"
    stats = Crawler.get_products(url)
    render(conn, "index.html", stats: stats)
  end
end
