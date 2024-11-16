class Admin::DashboardController < Admin::BaseController
  def index
    @pending_users = User.where(status: false, role: "trader")
    @approved_users = User.where(status: true, role: "trader")
  end
end
