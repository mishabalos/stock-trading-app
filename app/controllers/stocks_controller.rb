class StocksController < ApplicationController
  def intraday
    if params[:symbol].present?
      api = AlphaVantageApi.new
      @intraday_data = api.time_series_intraday(params[:symbol])
      if @intraday_data["Meta Data"].present?
        @latest_date = @intraday_data["Meta Data"]["3. Last Refreshed"]
        @latest_value = @intraday_data["Time Series (Daily)"]["#{@latest_date}"]["2. high"]
      else
        flash[:alert] = "Symbol not found"
      end
    end
  end
end
