# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    email { Faker::Internet.email }
    username { Faker::Name.name }
    password { '.test.' }
  end
end
