FactoryBot.define do
  factory :person do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { "+49 170 1234 1234" }
  end
end
