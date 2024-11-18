class User < ApplicationRecord
  before_create :set_default_role
  has_many :positions
  has_many :transactions

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates :first_name, presence: true
  validates :last_name, presence: true

  def is_trader?
    role == "trader"
  end

  def is_admin?
    role == "admin"
  end

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

  def full_name
    "#{first_name} #{last_name}"
  end

  def can_afford?(amount)
    balance >= amount
  end

  private

  def set_default_role
    self.role ||= "trader"
  end
end
