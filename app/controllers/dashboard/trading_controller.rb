class Dashboard::TradingController < Dashboard::BaseController
  before_action :fetch_stock_data, only: [ :new, :buy, :sell, :process_sell ]

  # Display all positions
  def index
    @positions = current_user.positions
  end

  # Form for new buy order
  def new
    @symbol = params[:symbol]
  end

  # Process buy order
  def buy
    result = TradeProcessor.new(
      current_user,
      params[:symbol],
      params[:quantity],
      @current_price
    ).buy

    # Redirect based on success/failure
    flash[result[:success] ? :notice : :alert] = result[:message]
    redirect_to result[:success] ? dashboard_portfolio_path : new_dashboard_trade_path(symbol: params[:symbol])
  end

  # Form for sell order
  def sell
    @position = current_user.positions.find_by!(symbol: params[:symbol])
    @max_quantity = @position.quantity
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Position not found"
    redirect_to dashboard_portfolio_path
  end

  # Process sell order
  def process_sell
    result = TradeProcessor.new(
      current_user,
      params[:symbol],
      params[:quantity],
      @current_price
    ).sell

    # Redirect based on success/failure
    flash[result[:success] ? :notice : :alert] = result[:message]
    redirect_to result[:success] ? dashboard_portfolio_path : sell_dashboard_trading_path(symbol: params[:symbol])
  end

  private

  # Fetch current stock data using cached service
  def fetch_stock_data
    api = CachedStockService.new
    @stock_data = api.fetch_intraday_data(params[:symbol])

    if @stock_data["Meta Data"].present?
      @latest_date = @stock_data["Meta Data"]["3. Last Refreshed"]
      @current_price = @stock_data["Time Series (Daily)"][@latest_date]["2. high"].to_f
      @symbol = @stock_data["Meta Data"]["2. Symbol"]
    else
      flash[:alert] = "Symbol not found"
      redirect_to stocks_search_path
    end
  end
end
