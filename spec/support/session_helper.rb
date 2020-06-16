# frozen_string_literal: true

module Support
  class SessionHelper
    def log_in_as(user_id)
      Session.create(user_id: id, key: 'test-session-key', expiry_date: 5.minutes.from_now)
    end
  end
end