class Dashboard::PagesController < Dashboard::BaseController
  def index
    @positions = current_user.positions || []  # Initialize as empty array if nil
  end
end
