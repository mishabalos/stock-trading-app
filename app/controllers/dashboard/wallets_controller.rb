class Dashboard::WalletsController < Dashboard::BaseController
  include ActionView::Helpers::NumberHelper

  def new
  end

  def top_up
    amount = params[:amount].to_f
    if amount > 0
      current_user.balance += amount
      if current_user.save
        flash[:notice] = "Successfully added #{number_to_currency(amount)} to your wallet"
        redirect_to dashboard_root_path
      else
        Rails.logger.error "Failed to update balance: #{current_user.errors.full_messages}"  # Add this line
        flash.now[:alert] = "Failed to update balance"
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Please enter a valid amount"
      render :new, status: :unprocessable_entity
    end
  end
end
