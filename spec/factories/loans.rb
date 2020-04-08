FactoryBot.define do
  factory :loan do
    name { "Name" }
    total_amount { 1.5 }
    date { "2020-04-08" }
    description { "Description" }
  end
end
