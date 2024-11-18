class Position < ApplicationRecord
  belongs_to :user

  validates :symbol, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :average_price, presence: true, numericality: { greater_than: 0 }

  def current_price
    api = AlphaVantageApi.new
    response = api.time_series_intraday(symbol)
    return 0.0 unless response["Time Series (Daily)"]  # Return 0.0 instead of nil
    latest_date = response["Time Series (Daily)"].keys.first
    latest_price = response["Time Series (Daily)"][latest_date]["4. close"]
    latest_price.to_f
  end

  def market_value
    price = current_price
    price.zero? ? 0.0 : quantity * price  # Handle zero price case
  end

  def profit_loss
    price = current_price
    price.zero? ? 0.0 : (price - average_price) * quantity
  end
end
