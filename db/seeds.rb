# frozen_string_literal: true

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'database_cleaner'
require 'factory_bot'

include FactoryBot::Syntax::Methods

# TODO: remove after fix is available
puts '⚠️ fsevent error is to be fixed in TPL and does not interfere with seeding' if Rails.env.development?

# Clear Database Upfront
puts 'Wiping database'
DatabaseCleaner.clean_with(:truncation, except: %w[ar_internal_metadata])
puts 'Database wiped'

# Users
puts 'Creating Users'
create(:user, email: 'admin@loan-manager.com', username: 'Admin_User', admin: true) # 1
create(:user, email: 'premium@loan-manager.com', username: 'Premium') # 2
create(:user, email: 'basic@loan-manager.com', username: 'Basic') # 3
puts "#{User.count} users created"

# Users -> People
puts 'Creating People'
first_names = %w[Steven Mike Laura Martin]
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

# Martin
create(:loan, name: 'Loan with Scheduled Payments', total_amount: -50, person_id: 7) # 11
create(:loan, name: 'Loan with Scheduled Payments', total_amount: -50, person_id: 8) # 12
create(:loan, name: 'Loan with overdue Scheduled Payments', total_amount: -30, person_id: 7) # 13
create(:loan, name: 'Loan with overdue Scheduled Payments', total_amount: -30, person_id: 8) # 14
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

# Users -> People -> Loans -> Scheduled Payments
puts 'Creating Scheduled Payments'
(1...5).each do |i|
  create(:scheduled_payment,
         description: "Scheduled Rate ##{i}",
         date: i.months.from_now,
         payment_amount: 10,
         loan_id: 11) # Uneven: Premium
  create(:scheduled_payment,
         description: "Scheduled Rate ##{i}",
         date: i.months.from_now,
         payment_amount: 10,
         loan_id: 12) # Even: Basic
end

create(:scheduled_payment,
       description: 'Overdue Rate',
       date: 15.days.ago,
       payment_amount: 15,
       loan_id: 13)
create(:scheduled_payment,
       description: 'Overdue Rate',
       date: 15.days.ago,
       payment_amount: 15,
       loan_id: 14)
puts "#{ScheduledPayment.count} scheduled payments created"
