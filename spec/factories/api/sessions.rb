# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory :api_session, class: 'Api::Session' do
    key { SecureRandom.hex }
    expiry_date { 1.days.from_now }
    user
  end
end
