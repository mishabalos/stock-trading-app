class Admin::UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :approve ]

  def index
    @users = User.where(role: "trader")
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User was successfully updated."
    else
      render :edit
    end
  end

  def approve
    if @user.update(status: true)
      UserMailer.approval_notification(@user).deliver_later  # You'll need to create this mailer
      redirect_to admin_users_path, notice: "User was successfully approved."
    else
      redirect_to admin_users_path, alert: "Error approving user."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:status)
  end
end
