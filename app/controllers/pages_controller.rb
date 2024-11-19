class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @stocks = [
      { symbol: "AAPL", name: "Apple Inc.", price: 150.25, volume: "78.9M", market_cap: "2.45T" },
      { symbol: "GOOGL", name: "Alphabet Inc.", price: 2750.80, volume: "1.2M", market_cap: "1.84T" },
      { symbol: "MSFT", name: "Microsoft Corporation", price: 305.15, volume: "23.5M", market_cap: "2.31T" },
      { symbol: "AMZN", name: "Amazon.com Inc.", price: 3380.50, volume: "3.7M", market_cap: "1.71T" }
    ]
  end
end
