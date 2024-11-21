class TradeProcessor
  def initialize(user, symbol, quantity, current_price)
    @user = user
    @symbol = symbol
    @quantity = quantity.to_i
    @current_price = current_price
  end

  def buy
    # Validate quantity
    return { success: false, message: "Invalid quantity" } if @quantity <= 0

    # Check if user can afford the purchase
    total_cost = @current_price * @quantity
    return { success: false, message: "Insufficient funds" } unless @user.can_afford?(total_cost)

    # Execute all operations within a transaction
    ActiveRecord::Base.transaction do
      position = update_position
      create_transaction("buy", total_cost)
      update_user_balance(-total_cost)

      { success: true, message: "Successfully bought #{@quantity} shares of #{@symbol}" }
    end
  rescue => e
    { success: false, message: "Failed to process purchase: #{e.message}" }
  end

  def sell
    # Find and validate position
    position = @user.positions.find_by(symbol: @symbol)
    return { success: false, message: "Position not found" } unless position
    return { success: false, message: "Invalid quantity" } if @quantity <= 0 || @quantity > position.quantity

    total_sale = @current_price * @quantity

    # Execute all operations within a transaction
    ActiveRecord::Base.transaction do
      update_position_for_sale(position)
      create_transaction("sell", total_sale)
      update_user_balance(total_sale)

      { success: true, message: "Successfully sold #{@quantity} shares of #{@symbol}" }
    end
  rescue => e
    { success: false, message: "Failed to process sale: #{e.message}" }
  end

  private

  def update_position
    position = @user.positions.find_or_initialize_by(symbol: @symbol)

    if position.new_record?
      # New position
      position.quantity = @quantity
      position.average_price = @current_price
    else
      # Update existing position with new average price
      total_shares = position.quantity + @quantity
      total_cost = (position.quantity * position.average_price) + (@quantity * @current_price)
      position.average_price = total_cost / total_shares
      position.quantity = total_shares
    end

    position.save!
    position
  end

  def update_position_for_sale(position)
    if @quantity == position.quantity
      # If selling all shares, remove the position
      position.destroy!
    else
      # Update remaining quantity
      position.update!(quantity: position.quantity - @quantity)
    end
  end

  def create_transaction(type, amount)
    # Record the transaction
    @user.transactions.create!(
      symbol: @symbol,
      transaction_type: type,
      quantity: @quantity,
      price: @current_price,
      total_amount: amount
    )
  end

  def update_user_balance(amount)
    # Update user's cash balance (negative for buys, positive for sells)
    @user.update_column(:balance, @user.balance + amount)
  end
end
