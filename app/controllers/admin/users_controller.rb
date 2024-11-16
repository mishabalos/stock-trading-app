class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :show, :edit, :update, :approve ]

  def index
    @users = User.where(role: "trader")
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(new_user_params)
    @user.role = "trader"
    @user.status = true

    if @user.save
      UserMailer.admin_created_account(@user).deliver_later
      redirect_to admin_users_path, notice: "Trader was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if user_params[:password].blank? && user_params[:password_confirmation].blank?
      if @user.update(user_params.except(:password, :password_confirmation))
        redirect_to admin_user_path(@user), notice: "User was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: "User was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
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

  def new_user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation
    )
  end


  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :status,
      :balance
    )
  end
end
