class Admin::DashboardController < ApplicationController
  def index
    @pending_users = User.where(status: false, role: "trader")
    @approved_users = User.where(status: true, role: "trader")
  end
end
