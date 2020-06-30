# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/people', type: :request do
  let(:valid_attributes) do
    {
      first_name: 'FirstName',
      last_name: 'LastName',
      phone_number: '+49 170 1234 1234',
      user_id: 3
    }
  end

  let(:invalid_attributes) do
    {
      first_name: '',
      last_name: '',
      phone_number: '',
      user_id: nil
    }
  end

  context 'Logged In' do
    before(:all) do
      @session = create :api_session, user_id: 3
    end

    describe 'index' do
      it 'shows the users persons' do
        get '/api/people/',
            params: {
              user_id: 3,
              session_key: @session.key
            }

        expect(response).to be_successful
        expect(JSON.parse(response.body).size).to eq 4
      end
    end

    describe 'create' do
      it 'creates a person' do
        expect do
          post '/api/people',
               params: {
                 user_id: 3,
                 session_key: @session.key,
                 payload: valid_attributes
               }

          expect(response).to be_successful
        end.to change(Person, :count).by 1
      end

      it 'does not create a user with invalid params' do
        expect do
          post '/api/people',
               params: {
                 user_id: 3,
                 session_key: @session.key,
                 payload: invalid_attributes
               }

          expect(response).to have_http_status 400
        end.not_to change(Person, :count)
      end
    end

    describe 'show' do
      it 'shows the person with its loans' do
        get '/api/people/2',
            params: {
              user_id: 3,
              session_key: @session.key
            }

        expect(response).to be_successful

        expect(JSON.parse(response.body)['loans'].size).to eq 1
      end

      it 'does not show persons of other users' do
        get '/api/people/3',
            params: {
              user_id: 3,
              session_key: @session.key
            }

        expect(response).to have_http_status 403
      end

      it 'shows forbidden if the person does not exist' do
        get '/api/people/-1',
            params: {
              user_id: 3,
              session_key: @session.key
            }

        expect(response).to have_http_status 403
      end
    end

    describe 'update' do
      let(:updated_attributes) do
        {
          first_name: 'changed_first',
          last_name: 'changed_last',
          phone_number: '+49 432 4321 4321',
          user_id: 3
        }
      end

      it 'updates the person' do
        patch '/api/people/2',
              params: {
                user_id: 3,
                session_key: @session.key,
                payload: updated_attributes
              }

        expect(response).to be_successful

        person = Person.find(2)
        expect(person.first_name).to eq 'changed_first'
        expect(person.last_name).to eq 'changed_last'
        expect(person.phone_number).to eq '+49 432 4321 4321'
      end

      it 'does not update persons of other users' do
        expect do
          patch '/api/people/3',
                params: {
                  user_id: 3,
                  session_key: @session.key,
                  payload: updated_attributes
                }

          expect(response).to have_http_status 403
        end.not_to change(Person.find(3), :first_name)
      end

      it 'shows forbidden if the person does not exist' do
        patch '/api/people/-1',
              params: {
                user_id: 3,
                session_key: @session.key,
                payload: updated_attributes
              }

        expect(response).to have_http_status 403
      end
    end

    describe 'destroy' do
      it 'destroys the person' do
        expect do
          delete '/api/people/2',
                 params: {
                   user_id: 3,
                   session_key: @session.key
                 }

          expect(response).to be_successful
        end.to change(Person, :count).by(-1)
      end

      it 'does not destroy persons of other users' do
        expect do
          delete '/api/people/3',
                 params: {
                   user_id: 3,
                   session_key: @session.key
                 }

          expect(response).to have_http_status 403
        end.not_to change(Person, :count)
      end

      it 'shows forbidden if the person does not exist' do
        expect do
          delete '/api/people/-1',
                 params: {
                   user_id: 3,
                   session_key: @session.key
                 }
          expect(response).to have_http_status 403
        end.not_to change(Person, :count)
      end
    end
  end

  context 'Logged Out' do
    it 'index is locked' do
      get '/api/people'
      expect(response).to have_http_status 403
    end

    it 'create is locked' do
      expect do
        get '/api/people',
            params: {
              payload: valid_attributes
            }

        expect(response).to have_http_status 403
      end.not_to change(Person, :count)
    end

    it 'show is locked' do
      get '/api/people/1'
      expect(response).to have_http_status 403
    end

    it 'update is locked' do
      expect do
        patch '/api/people/1',
              params: {
                payload: valid_attributes
              }

        expect(response).to have_http_status 403
      end.not_to change(Person.find(1), :first_name)
    end

    it 'destroy is locked' do
      expect do
        delete '/api/people/1',
               params: {}

        expect(response).to have_http_status 403
      end.not_to change(Person, :count)
    end
  end
end
