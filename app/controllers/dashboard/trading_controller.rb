# app/controllers/dashboard/trading_controller.rb
class Dashboard::TradingController < Dashboard::BaseController
  before_action :fetch_stock_data, only: [ :new, :buy ]

  def index
    @positions = current_user.positions
  end

  def new
    @symbol = params[:symbol]
  end

  def buy
    quantity = params[:quantity].to_i
    total_cost = @current_price * quantity

    if quantity <= 0
      flash[:alert] = "Please enter a valid quantity"
      return redirect_to new_dashboard_trade_path(symbol: params[:symbol])
    end

    if !current_user.can_afford?(total_cost)
      flash[:alert] = "Insufficient funds"
      return redirect_to new_dashboard_trade_path(symbol: params[:symbol])
    end

    ActiveRecord::Base.transaction do
      # Find or create position
      position = current_user.positions.find_or_initialize_by(symbol: params[:symbol])

      # Update position
      if position.new_record?
        position.quantity = quantity
        position.average_price = @current_price
      else
        # Calculate new average price
        total_shares = position.quantity + quantity
        total_cost_basis = (position.quantity * position.average_price) + (quantity * @current_price)
        position.average_price = total_cost_basis / total_shares
        position.quantity = total_shares
      end

      # Create transaction record
      current_user.transactions.create!(
        symbol: params[:symbol],
        transaction_type: "buy",
        quantity: quantity,
        price: @current_price,
        total_amount: total_cost
      )

      # Update user's balance
      current_user.update_column(:balance, current_user.balance - total_cost)

      if position.save
        flash[:notice] = "Successfully bought #{quantity} shares of #{params[:symbol]}"
        redirect_to dashboard_portfolio_path
      else
        raise ActiveRecord::Rollback
        flash[:alert] = "Failed to process purchase"
        redirect_to new_dashboard_trade_path(symbol: params[:symbol])
      end
    end
  end

  def sell
    @position = current_user.positions.find_by!(symbol: params[:symbol])
    fetch_stock_data
    @max_quantity = @position.quantity
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Position not found"
    redirect_to dashboard_portfolio_path
  end

  def process_sell
    @position = current_user.positions.find_by!(symbol: params[:symbol])
    quantity = params[:quantity].to_i
    fetch_stock_data

    if quantity <= 0 || quantity > @position.quantity
      flash[:alert] = "Please enter a valid quantity"
      return redirect_to sell_dashboard_trading_path(symbol: params[:symbol])
    end

    total_sale = @current_price * quantity

    ActiveRecord::Base.transaction do
      # Update position
      if quantity == @position.quantity
        @position.destroy!
      else
        @position.update!(quantity: @position.quantity - quantity)
      end

      # Create transaction record
      current_user.transactions.create!(
        symbol: params[:symbol],
        transaction_type: "sell",
        quantity: quantity,
        price: @current_price,
        total_amount: total_sale
      )

      # Update user's balance
      current_user.update_column(:balance, current_user.balance + total_sale)

      flash[:notice] = "Successfully sold #{quantity} shares of #{params[:symbol]}"
      redirect_to dashboard_portfolio_path
    end
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Position not found"
    redirect_to dashboard_portfolio_path
  end

  private

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
