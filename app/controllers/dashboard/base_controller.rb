class Dashboard::BaseController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :ensure_trader

  private

  def ensure_trader
    unless (current_user&.role == "trader" && current_user.status == true) || current_user&.role == "admin"
      flash[:alert] = "You are not authorized to access this area."
      redirect_to root_path
    end
  end
end
