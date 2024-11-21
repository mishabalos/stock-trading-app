require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do |example|
    puts "\nRunning: #{example.metadata[:full_description]}"
  end
 # Create a test user object that can be reused across multiple tests
 let(:user) {
   User.new(
     first_name: 'John',
     last_name: 'Doe',
     email: 'john@example.com',
     password: 'password123'
   )
 }

 describe 'validations' do
   # Test that user object is valid when all required fields are present
   it 'is valid with required attributes' do
     expect(user).to be_valid
   end

   # Test presence validation for first_name
   it 'requires first name' do
     user.first_name = nil
     expect(user).not_to be_valid
   end

   # Test presence validation for last_name
   it 'requires last name' do
     user.last_name = nil
     expect(user).not_to be_valid
   end
 end

 # Test the full_name instance method
 describe '#full_name' do
   it 'returns combined first and last name' do
     expect(user.full_name).to eq('John Doe')
   end
 end

 # Group tests related to user roles
 describe 'roles' do
   # Test the default role setting functionality
   it 'sets trader as default role' do
     user.save
     expect(user.is_trader?).to be true
   end

   # Test that role can be changed to admin
   it 'can be admin' do
     user.role = 'admin'
     expect(user.is_admin?).to be true
   end
 end

 # Test the can_afford? instance method
 describe '#can_afford?' do
   # Test when user has sufficient balance
   it 'returns true if balance is sufficient' do
     user.balance = 1000
     expect(user.can_afford?(500)).to be true
   end

   # Test when user has insufficient balance
   it 'returns false if balance is insufficient' do
     user.balance = 100
     expect(user.can_afford?(500)).to be false
   end
 end
end
