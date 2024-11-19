class Dashboard::TransactionsController < Dashboard::BaseController
  def index
    @transactions = current_user.transactions.order(created_at: :desc)
  end
end
