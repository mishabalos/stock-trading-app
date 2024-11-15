require "test_helper"

class StocksControllerTest < ActionDispatch::IntegrationTest
  test "should get intraday" do
    get stocks_intraday_url
    assert_response :success
  end
end
