# frozen_string_literal: true

FactoryBot.define do
  factory :loan do
    name { Faker::App.name }
    total_amount { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    date { Faker::Date.between(from: 2.weeks.ago, to: 1.week.ago) }
    description { Faker::Lorem.paragraph }
    person
  end
end
