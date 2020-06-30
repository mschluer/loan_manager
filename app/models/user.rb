# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  has_many :people, foreign_key: 'user_id', class_name: 'Person', dependent: :destroy
  has_many :api_sessions, foreign_key: 'user_id', class_name: 'Api::Session', dependent: :destroy

  def switch_admin_access!
    self.admin = !admin
    save!
  end

  # Exclude Feature Envy as a session should not delete itself
  # :reek:FeatureEnvy
  def validate_sessions
    api_sessions.each do |session|
      session.destroy if session.expired?
    end
  end

  # Control Parameter is necessary here as possibly all sessions for
  # a user have to be checked
  # :reek:ControlParameter
  def session_with?(session_key)
    api_sessions.each do |session|
      return true if session.key == session_key
    end

    false
  end

  def kill_all_sessions
    api_sessions.each(&:destroy)
  end
end
