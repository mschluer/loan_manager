FactoryBot.define do
  factory :payment do
    payment_amount { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    date { Faker::Date.between(from: 5.days.ago, to: 2.days.ago) }
    description { Faker::Lorem.paragraph }
  end
end
