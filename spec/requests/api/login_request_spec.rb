# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Login', type: :request do
  let(:valid_attributes) do
    {
      username: 'Basic',
      password: '.test.'
    }
  end

  let(:invalid_attributes) do
    {
      username: 'Basic',
      password: 'wrong password'
    }
  end

  describe 'Log In Functionality' do
    describe 'POST /api/login' do
      it 'increases the amount of sessions by one if successful' do
        expect do
          post '/api/login',
               params: {
                 payload: valid_attributes
               }

          expect(response).to be_successful
        end.to change(Api::Session, :count).by 1
      end

      it 'does not increase the amount of sessions if failed' do
        expect do
          post '/api/login',
               params: {
                 payload: invalid_attributes
               }

          expect(response).to have_http_status 422
        end.not_to change(Api::Session, :count)
      end
    end
  end

  describe 'Log Out Functionality' do
    let(:user) { create :user }

    before(:each) do
      @session = create(:api_session, user_id: user.id)
    end

    describe 'POST /api/logout' do
      it 'reduces the amount of sessions by one if key and username are transmitted' do
        expect do
          post '/api/logout',
               params: {
                 user_id: user.id,
                 session_key: @session.key,
                 payload: {}
               }

          expect(response).to be_successful
        end.to change(Api::Session, :count).by(-1)
      end

      it 'does not reduce the amount of sessions by one if only a key is transmitted' do
        expect do
          post '/api/logout',
               params: {
                 session_key: @session.key,
                 payload: {}
               }

          expect(response).not_to be_successful
        end.not_to change(Api::Session, :count)
      end

      it 'does not reduce the amount of session if only a user id is transmitted' do
        expect do
          post '/api/logout',
               params: {
                 user_id: user.id,
                 payload: {}
               }

          expect(response).not_to be_successful
        end.not_to change(Api::Session, :count)
      end

      it 'does not reduce the amount of sessions if session and user id are empty' do
        expect do
          post '/api/logout',
               params: {
                 payload: {}
               }

          expect(response).not_to be_successful
        end.not_to change(Api::Session, :count)
      end

      it 'is not possible to kill a session for another user' do
        other_session = create(:api_session)

        expect do
          post '/api/logout',
               params: {
                   user_id: user.id,
                   session_key: other_session.key,
                   payload: {}
               }

          expect(response).not_to be_successful
        end.not_to change(Api::Session, :count)

        expect do
          post '/api/logout',
               params: {
                   user_id: user.id,
                   session_key: @session.key,
                   payload: {}
               }

          expect(response).to be_successful
        end.to change(Api::Session, :count).by(-1)
      end
    end

    describe 'POST /api/logout_all' do
      before(:each) do
        @second_session = create :api_session, user_id: user.id
      end

      it 'closes all sessions for a user if key of the first session and user_id are transmitted' do
        expect do
          post '/api/logout_all',
               params: {
                   user_id: user.id,
                   session_key: @session.key,
                   payload: {}
               }

          expect(response).to be_successful
        end.to change(Api::Session, :count).by(-2)
      end

      it 'closes all sessions for a user if key of the second session and user_id are transmitted' do
        expect do
          post '/api/logout_all',
               params: {
                   user_id: user.id,
                   session_key: @second_session.key,
                   payload: {}
               }

          expect(response).to be_successful
        end.to change(Api::Session, :count).by(-2)
      end

      it 'does not reduce the amount of sessions if only a user id is transmitted' do
        expect do
          post '/api/logout_all',
               params: {
                   user_id: user.id,
                   payload: {}
               }

          expect(response).not_to be_successful
        end.not_to change(Api::Session, :count)
      end

      it 'does not reduce the amount of sessions if only a key is transmitted' do
        expect do
          post '/api/logout_all',
               params: {
                   session_key: @session.key,
                   payload: {}
               }

          expect(response).not_to be_successful
        end.not_to change(Api::Session, :count)
      end

      it 'does not reduce the amount of sessions if session and user id are empty' do
        expect do
          post '/api/logout_all',
               params: {
                 payload: {}
               }

          expect(response).not_to be_successful
        end.not_to change(Api::Session, :count)
      end

      it 'is not possible to kill sessions of another user' do
        other_session = create(:api_session)

        expect do
          post '/api/logout_all',
               params: {
                 user_id: user.id,
                 session_key: other_session.key,
                 payload: {}
               }

          expect(response).not_to be_successful
        end.not_to change(Api::Session, :count)

        expect do
          post '/api/logout_all',
               params: {
                 user_id: user.id,
                 session_key: @session.key,
                 payload: {}
               }

          expect(response).to be_successful
        end.to change(Api::Session, :count).by(-2)
      end
    end
  end
end