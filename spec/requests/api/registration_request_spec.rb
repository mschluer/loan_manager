# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Registration', type: :request do
  let(:valid_attributes) do
    {
      email: 'test_lab@dakalabs.com',
      username: 'api_test_valid',
      password: '.test.',
      password_confirmation: '.test.'
    }
  end

  let(:invalid_attributes) do
    {
      email: '',
      username: '',
      password: '',
      password_confirmation: ''
    }
  end

  describe 'POST /api/register' do
    it 'increases the amount of users by one without session' do
      expect do
        post '/api/register',
             params: {
               payload: valid_attributes
             }
      end.to change(User, :count).by 1
    end

    it 'increases the amount of users by one with session' do
      session = create(:api_session, user_id: 1)

      expect do
        post '/api/register',
             params: {
               user_id: 1,
               session_key: session.key,
               payload: valid_attributes
             }
      end.to change(User, :count).by 1
    end

    it 'does not increase the amount of users if attributes are invalid' do
      expect do
        post '/api/register',
             params: {
               payload: invalid_attributes
             }
      end.not_to change(User, :count)
    end

    it 'does not increase the amount of users if the password confirmation is missing' do
      valid_attributes[:password_confirmation] = ''

      expect do
        post '/api/register',
             params: {
               payload: valid_attributes
             }
      end.not_to change(User, :count)
    end
  end
end
