class CachedStockService
  CACHE_DURATION = 60.minutes
  REFRESH_THRESHOLD = 59.minutes

  def initialize
    @api = AlphaVantageApi.new
  end

  def fetch_intraday_data(symbol)
    cache_key = "stock_data/#{symbol}"
    cached_data = Rails.cache.read(cache_key)
    Rails.logger.debug "Cache hit: #{!cached_data.nil?}"
    # Rails.logger.debug "Cache near expiry: #{cache_near_expiry?(cache_key)}" if cached_data
    return cached_data if cached_data && !cache_near_expiry?(cache_key)

    if cached_data && cache_near_expiry?(cache_key)
      refresh_cache_async(symbol, cache_key)
      return cached_data
    end

    # Rails.logger.debug "Fetching fresh data from API"
    fetch_and_cache_data(symbol, cache_key)
  end

  private

  def cache_near_expiry?(cache_key)
    entry = Rails.cache.read(cache_key)
    return false unless entry

    # Check if cache was created more than REFRESH_THRESHOLD ago
    cache_created_at = Rails.cache.read("#{cache_key}_created_at")
    # Rails.logger.debug "Cache created at: #{cache_created_at}"
    return false unless cache_created_at

    is_expiring = Time.now > (cache_created_at + REFRESH_THRESHOLD)
    # Rails.logger.debug "Is cache expiring? #{is_expiring}"
    is_expiring
  end

  def fetch_and_cache_data(symbol, cache_key)
    data = @api.time_series_intraday(symbol)
    Rails.cache.write(cache_key, data, expires_in: CACHE_DURATION)
    Rails.cache.write("#{cache_key}_created_at", Time.now, expires_in: CACHE_DURATION)
    data
  end

  def refresh_cache_async(symbol, cache_key)
    RefreshStockCacheJob.perform_later(symbol, cache_key)
  end
end
