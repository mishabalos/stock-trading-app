class UserMailer < ApplicationMailer
  def approval_notification(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Your trading account has been approved!"
    )
  end
end
