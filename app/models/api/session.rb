# frozen_string_literal: true

require 'securerandom'

module Api
  class Session < ApplicationRecord
    belongs_to :user

    validates_presence_of :user_id
    validates_presence_of :expiry_date
    validates_presence_of :key

    def expired?
      DateTime.now > expiry_date
    end

    def set_key
      self.key = SecureRandom.hex
    end
  end
end
