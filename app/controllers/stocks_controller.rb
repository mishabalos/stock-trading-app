class StocksController < ApplicationController
  def intraday
    if params[:symbol].present?
      api = AlphaVantageApi.new
      @intraday_data = api.time_series_intraday(params[:symbol])
      @latest_date = @intraday_data["Meta Data"]["3. Last Refreshed"]
      @latest_value = @intraday_data["Time Series (Daily)"]["#{@latest_date}"]["2. high"]
    end
  end
end
