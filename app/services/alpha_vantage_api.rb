require "uri"
require "net/http"
require "json"

class AlphaVantageApi
  API_HOST = "alpha-vantage.p.rapidapi.com".freeze
  BASE_URL = "https://#{API_HOST}/query".freeze

  def initialize
    @api_key = ENV["ALPHAVANTAGE_API_KEY"]
  end

  def time_series_intraday(symbol)
    url = URI("#{BASE_URL}?function=TIME_SERIES_DAILY&symbol=#{symbol}&outputsize=compact&datatype=json")
    make_request(url)
  end

  private

  def make_request(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = @api_key
    request["x-rapidapi-host"] = API_HOST

    response = http.request(request)
    JSON.parse(response.read_body)
  end
end
