# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Session, type: :model do
  before(:each) { @api_session = create :api_session }

  it 'is valid with user_id, expiry_date and key' do
    expect(@api_session).to be_valid
  end

  it 'is not valid without a user' do
    @api_session.user = nil

    expect(@api_session).not_to be_valid
  end

  it 'is not valid without expiry_date' do
    @api_session.expiry_date = nil

    expect(@api_session).not_to be_valid
  end

  it 'is not valid without a key' do
    @api_session.key = nil

    expect(@api_session).not_to be_valid
  end

  describe 'expired?' do
    it 'is not expired, if the expiry date is in the future' do
      @api_session.expiry_date = 1.day.from_now

      expect(@api_session).not_to be_expired
    end

    it 'is expired, if the expiry date is in the past' do
      @api_session.expiry_date = 1.day.ago

      expect(@api_session).to be_expired
    end
  end
end
