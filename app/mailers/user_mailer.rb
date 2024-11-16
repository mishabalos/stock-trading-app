class UserMailer < ApplicationMailer
  def approval_notification(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Your trading account has been approved!"
    )
  end

  def admin_created_account(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Your Trading Account Has Been Created"
    )
  end
end
