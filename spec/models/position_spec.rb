require 'rails_helper'

RSpec.describe Position, type: :model do
  before(:each) do |example|
    puts "\nRunning: #{example.metadata[:full_description]}"
  end
 # Set up a basic position and user for testing
 let(:user) { User.create(first_name: 'John', last_name: 'Doe', email: 'john@example.com', password: 'password123') }
 let(:position) {
   Position.new(
     user: user,
     symbol: 'AAPL',
     quantity: 10,
     average_price: 150.00
   )
 }

 # Test basic model validations
 describe 'validations' do
   it 'is valid with valid attributes' do
     expect(position).to be_valid
   end

   it 'requires a symbol' do
     position.symbol = nil
     expect(position).not_to be_valid
   end

   it 'requires a quantity' do
     position.quantity = nil
     expect(position).not_to be_valid
   end

   it 'requires quantity to be an integer' do
     position.quantity = 10.5
     expect(position).not_to be_valid
   end

   it 'requires a positive average price' do
     position.average_price = 0
     expect(position).not_to be_valid
   end
 end

 # Test market value calculations
 describe '#market_value' do
   before do
     # Mock the stock service response
     service = instance_double(CachedStockService)
     allow(CachedStockService).to receive(:new).and_return(service)
     allow(service).to receive(:fetch_intraday_data).and_return({
       "Time Series (Daily)" => {
         "2024-03-21" => { "4. close" => "180.00" }
       }
     })
   end

   it 'calculates market value based on current price' do
     expect(position.market_value).to eq(1800.00) # 10 shares * $180
   end

   it 'returns 0 when price data is unavailable' do
     service = instance_double(CachedStockService)
     allow(CachedStockService).to receive(:new).and_return(service)
     allow(service).to receive(:fetch_intraday_data).and_return({})

     expect(position.market_value).to eq(0.0)
   end
 end

 # Test profit/loss calculations
 describe '#profit_loss' do
   before do
     # Mock the stock service response
     service = instance_double(CachedStockService)
     allow(CachedStockService).to receive(:new).and_return(service)
     allow(service).to receive(:fetch_intraday_data).and_return({
       "Time Series (Daily)" => {
         "2024-03-21" => { "4. close" => "180.00" }
       }
     })
   end

   it 'calculates positive profit/loss' do
     # Bought at 150, current price 180, for 10 shares = 300 profit
     expect(position.profit_loss).to eq(300.00)
   end

   it 'calculates negative profit/loss' do
     service = instance_double(CachedStockService)
     allow(CachedStockService).to receive(:new).and_return(service)
     allow(service).to receive(:fetch_intraday_data).and_return({
       "Time Series (Daily)" => {
         "2024-03-21" => { "4. close" => "140.00" }
       }
     })

     # Bought at 150, current price 140, for 10 shares = -100 loss
     expect(position.profit_loss).to eq(-100.00)
   end
 end
end
