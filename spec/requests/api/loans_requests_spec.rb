# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/loans', type: :request do
  let(:valid_attributes) do
    {
      name: 'valid name',
      total_amount: 5.0,
      date: 1.day.ago,
      description: 'valid description',
      person_id: 2
    }
  end

  let(:invalid_attributes) do
    {
      name: nil,
      total_amount: nil,
      date: nil,
      description: nil
    }
  end

  context 'Logged In' do
    before(:all) do
      @session = create :api_session, user_id: 3
    end

    describe 'index' do
      it 'shows the persons loans' do
        get '/api/loans/',
            params: {
              user_id: 3,
              session_key: @session.key
            }

        expect(response).to be_successful
        expect(JSON.parse(response.body).size).to eq 7
      end
    end

    describe 'create' do
      it 'creates a loan' do
        expect do
          post '/api/loans',
               params: {
                 user_id: 3,
                 session_key: @session.key,
                 payload: valid_attributes
               }

          expect(response).to be_successful
        end.to change(Loan, :count).by 1
      end

      it 'does not create a loan with invalid params' do
        expect do
          post '/api/loans',
               params: {
                 user_id: 3,
                 session_key: @session.key,
                 payload: invalid_attributes
               }

          expect(response).to have_http_status 400
        end.not_to change(Loan, :count)
      end
    end

    describe 'show' do
      it 'shows the loan with its payments' do
        get '/api/loans/2',
            params: {
              user_id: 3,
              session_key: @session.key
            }

        expect(response).to be_successful

        expect(JSON.parse(response.body)['payments'].size).to eq 3
      end

      it 'does not show loans of other users' do
        get '/api/loans/1',
            params: {
              user_id: 3,
              session_key: @session.key
            }

        expect(response).to have_http_status 403
      end

      it 'shows forbidden if the loan does not exist' do
        get '/api/loans/-1',
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
          name: 'updated name',
          total_amount: 10.0,
          date: 2.days.ago,
          description: 'updated description',
          person_id: 2
        }
      end

      it 'updates the loan' do
        patch '/api/loans/2',
              params: {
                user_id: 3,
                session_key: @session.key,
                payload: updated_attributes
              }

        expect(response).to be_successful

        loan = Loan.find(2)
        expect(loan.name).to eq 'updated name'
        expect(loan.total_amount).to eq 10.0
        expect(loan.description).to eq 'updated description'
      end

      it 'does not update loans of other users' do
        expect do
          patch '/api/loans/3',
                params: {
                  user_id: 3,
                  session_key: @session.key,
                  payload: updated_attributes
                }

          expect(response).to have_http_status 403
        end.not_to change(Loan.find(3), :name)
      end

      it 'shows forbidden if the loan does not exist' do
        patch '/api/loans/-1',
              params: {
                user_id: 3,
                session_key: @session.key,
                payload: updated_attributes
              }

        expect(response).to have_http_status 403
      end
    end

    describe 'destroy' do
      it 'destroys the loan' do
        expect do
          delete '/api/loans/2',
                 params: {
                   user_id: 3,
                   session_key: @session.key
                 }

          expect(response).to be_successful
        end.to change(Loan, :count).by(-1)
      end

      it 'does not destroy loans of other users' do
        expect do
          delete '/api/loans/3',
                 params: {
                   user_id: 3,
                   session_key: @session.key
                 }

          expect(response).to have_http_status 403
        end.not_to change(Loan, :count)
      end

      it 'shows forbidden if the loan does not exist' do
        expect do
          delete '/api/loans/-1',
                 params: {
                   user_id: 3,
                   session_key: @session.key
                 }
          expect(response).to have_http_status 403
        end.not_to change(Loan, :count)
      end
    end
  end

  context 'Logged Out' do
    it 'index is locked' do
      get '/api/loans'
      expect(response).to have_http_status 403
    end

    it 'create is locked' do
      expect do
        get '/api/loans',
            params: {
              payload: valid_attributes
            }

        expect(response).to have_http_status 403
      end.not_to change(Loan, :count)
    end

    it 'show is locked' do
      get '/api/loans/1'
      expect(response).to have_http_status 403
    end

    it 'update is locked' do
      expect do
        patch '/api/loans/1',
              params: {
                payload: valid_attributes
              }

        expect(response).to have_http_status 403
      end.not_to change(Loan.find(1), :name)
    end

    it 'destroy is locked' do
      expect do
        delete '/api/loans/1',
               params: {}

        expect(response).to have_http_status 403
      end.not_to change(Loan, :count)
    end
  end
end
