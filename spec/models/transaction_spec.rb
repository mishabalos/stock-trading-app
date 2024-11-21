require 'rails_helper'

RSpec.describe Transaction, type: :model do
 before(:each) do |example|
   puts "\nRunning: #{example.metadata[:full_description]}"
 end

 # Set up basic transaction and user for testing
 let(:user) { User.create(first_name: 'John', last_name: 'Doe', email: 'john@example.com', password: 'password123') }
 let(:transaction) {
   Transaction.new(
     user: user,
     symbol: 'AAPL',
     transaction_type: 'buy',
     quantity: 10,
     price: 150.00,
     total_amount: 1500.00
   )
 }

 # Test basic validations
 describe 'validations' do
   it 'is valid with valid attributes' do
     expect(transaction).to be_valid
   end

   it 'requires a symbol' do
     transaction.symbol = nil
     expect(transaction).not_to be_valid
   end

   it 'requires a valid transaction type' do
     transaction.transaction_type = 'invalid'
     expect(transaction).not_to be_valid
   end

   it 'accepts buy transaction type' do
     transaction.transaction_type = 'buy'
     expect(transaction).to be_valid
   end

   it 'accepts sell transaction type' do
     transaction.transaction_type = 'sell'
     expect(transaction).to be_valid
   end

   it 'requires positive quantity' do
     transaction.quantity = 0
     expect(transaction).not_to be_valid
   end

   it 'requires positive price' do
     transaction.price = 0
     expect(transaction).not_to be_valid
   end

   it 'requires positive total amount' do
     transaction.total_amount = 0
     expect(transaction).not_to be_valid
   end
 end

 # Test scopes
 describe 'scopes' do
   before do
     # Create sample transactions
     Transaction.create(
       user: user,
       symbol: 'AAPL',
       transaction_type: 'buy',
       quantity: 10,
       price: 150.00,
       total_amount: 1500.00
     )
     Transaction.create(
       user: user,
       symbol: 'AAPL',
       transaction_type: 'sell',
       quantity: 5,
       price: 160.00,
       total_amount: 800.00
     )
   end

   it 'filters buy orders' do
     buy_orders = Transaction.buy_orders
     expect(buy_orders.count).to eq(1)
     expect(buy_orders.first.transaction_type).to eq('buy')
   end

   it 'filters sell orders' do
     sell_orders = Transaction.sell_orders
     expect(sell_orders.count).to eq(1)
     expect(sell_orders.first.transaction_type).to eq('sell')
   end
 end

 # Test associations
 describe 'associations' do
   it 'belongs to a user' do
     transaction.user = nil
     expect(transaction).not_to be_valid
   end
 end

 # Test total amount calculation scenarios
 describe 'total amount scenarios' do
   it 'matches quantity times price' do
     transaction.quantity = 10
     transaction.price = 150.00
     transaction.total_amount = 1500.00
     expect(transaction).to be_valid
   end
 end
end
