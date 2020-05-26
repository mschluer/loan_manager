FactoryBot.define do
  factory :scheduled_payment do
    payment_amount { "" }
    date { "" }
    description { "" }
    loan_id { 1 }
  end
end
