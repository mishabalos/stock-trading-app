class RefreshStockCacheJob < ApplicationJob
  queue_as :default

  def perform(symbol, cache_key)
    api = AlphaVantageApi.new
    data = api.time_series_intraday(symbol)
    Rails.cache.write(cache_key, data, expires_in: CachedStockService::CACHE_DURATION)
  end
end
