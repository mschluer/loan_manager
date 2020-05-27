FactoryBot.define do
  factory :scheduled_payment do
    payment_amount { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    date { Faker::Date.between(from: 5.days.from_now, to: 1.year.from_now) }
    description { Faker::Lorem.word }
    loan
  end
end
