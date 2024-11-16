class UsersController < ApplicationController
  def approve
    @user = User.find(params[:id])
    if @user.approve!
      flash[:notice] = "User was successfully approved"
      redirect_to users_path
    else
      flash[:error] = "Failed to approve user"
      redirect_to users_path
    end
  end
end
