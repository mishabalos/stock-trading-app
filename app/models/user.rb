class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  def approved?
    status
  end

  def approve!
    if update(approved: true)
      # deliver_later puts the email in a background job
      UserMailer.approval_notification(self).deliver_later
      true
    else
      false
    end
  end
end
