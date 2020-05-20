abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'database_cleaner'
require 'factory_bot'

include FactoryBot::Syntax::Methods

# Clear Database Upfront
puts 'Wiping database'
DatabaseCleaner.clean_with(:truncation, except: %w(ar_internal_metadata))
puts 'Database wiped'

# Users
puts 'Creating Users'
create(:user, email: 'admin@loan-manager.com', username: 'Admin_User') # 1
create(:user, email: 'premium@loan-manager.com', username: 'Premium') # 2
create(:user, email: 'basic@loan-manager.com', username: 'Basic') # 3
puts "#{User.count} users created"

# Users -> People
puts 'Creating People'
first_names = %w(Steven Mike Laura)
first_names.each do |first_name|
  create(:person, first_name: first_name, last_name: 'Premium', user_id: 2) # Uneven Numbers: Premium
  create(:person, first_name: first_name, last_name: 'Basic', user_id: 3) # Even Numbers: Basic
end
puts "#{Person.count} people created"

# Users -> People -> Loans
puts 'Creating Loans'
# Steve
create(:loan, name: 'Entirely Paid Loan', total_amount: -50, person_id: 1) # 1
create(:loan, name: 'Entirely Paid Loan', total_amount: -50, person_id: 2) # 2

# Mike
create(:loan, name: 'Negative Loan', total_amount: 30, person_id: 3) # 3
create(:loan, name: 'Negative Loan', total_amount: 30, person_id: 4) # 4
create(:loan, name: 'Partially Paid Loan', total_amount: -25, person_id: 3) # 5
create(:loan, name: 'Partially Paid Loan', total_amount: -25, person_id: 4) # 6

# Laura
create(:loan, name: 'Small Loan 1', total_amount: -10, person_id: 5) # 7
create(:loan, name: 'Small Loan 1', total_amount: -10, person_id: 6) # 8
create(:loan, name: 'Small Loan 2', total_amount: -20, person_id: 5) # 9
create(:loan, name: 'Small Loan 2', total_amount: -20, person_id: 6) # 10
puts "#{Loan.count} loans created"

# Users -> People -> Loans -> Payments
puts 'Creating Payments'
# Entirely Paid Loan
create(:payment, description: 'First Rate', payment_amount: 10, loan_id: 1)
create(:payment, description: 'First Rate', payment_amount: 10, loan_id: 2)
create(:payment, description: 'Second Rate', payment_amount: 20, loan_id: 1)
create(:payment, description: 'Second Rate', payment_amount: 20, loan_id: 2)
create(:payment, description: 'Third Rate', payment_amount: 20, loan_id: 1)
create(:payment, description: 'Third Rate', payment_amount: 20, loan_id: 2)

# Partially Paid Loan
create(:payment, description: 'Partial Payment', payment_amount: 15, loan_id: 5)
create(:payment, description: 'Partial Payment', payment_amount: 15, loan_id: 6)
puts "#{Payment.count} payments created"