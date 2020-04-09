FactoryBot.define do
  factory :payment do
    payment_amount { 1.5 }
    date { "2020-04-09" }
    description { "MyText" }
  end
end
