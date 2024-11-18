class Transaction < ApplicationRecord
  belongs_to :user
  
  validates :symbol, presence: true
  validates :transaction_type, presence: true, inclusion: { in: %w[buy sell] }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  scope :buy_orders, -> { where(transaction_type: 'buy') }
  scope :sell_orders, -> { where(transaction_type: 'sell') }
end
