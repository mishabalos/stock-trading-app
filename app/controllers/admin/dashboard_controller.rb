class Admin::DashboardController < Admin::BaseController
  def index
    @pending_users = User.where(status: false, role: "trader")
    @approved_users = User.where(status: true, role: "trader")
  end

  def transactions
    # get all transactions but paginate it by 20 at a time
    @transactions = Transaction.all.page(params[:page]).order(created_at: :desc)
  end
end
