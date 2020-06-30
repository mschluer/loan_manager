# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/scheduled_payments', type: :request do
  let(:valid_attributes) do
    {
      payment_amount: 5.0,
      date: '2021-04-09',
      description: 'scheduled_payment_text',
      loan_id: 2
    }
  end

  let(:invalid_attributes) do
    {
      payment_amount: nil,
      date: nil,
      description: nil,
      loan_id: 2
    }
  end

  context 'Logged In' do
    before(:all) do
      @session = create :api_session, user_id: 3
    end

    describe 'index' do
      it 'shows the users scheduled payments' do
        get '/api/scheduled_payments',
            params: {
              user_id: 3,
              session_key: @session.key
            }

        expect(response).to be_successful
        expect(JSON.parse(response.body).size).to eq 5
      end
    end

    describe 'create' do
      it 'creates a scheduled payment' do
        expect do
          post '/api/scheduled_payments',
               params: {
                 user_id: 3,
                 session_key: @session.key,
                 payload: valid_attributes
               }

          expect(response).to be_successful
        end.to change(ScheduledPayment, :count).by 1
      end

      it 'does not create a scheduled payment with invalid params' do
        expect do
          post '/api/scheduled_payments',
               params: {
                 user_id: 3,
                 session_key: @session.key,
                 payload: invalid_attributes
               }

          expect(response).to have_http_status 400
        end.not_to change(ScheduledPayment, :count)
      end
    end

    describe 'show' do
      it 'shows the scheduled payment' do
        get '/api/scheduled_payments/2',
            params: {
              user_id: 3,
              session_key: @session.key
            }

        expect(response).to be_successful
      end

      it 'does not show scheduled payments of other users' do
        get '/api/scheduled_payments/1',
            params: {
              user_id: 3,
              session_key: @session.key
            }

        expect(response).to have_http_status 403
      end

      it 'shows forbidden if the scheduled payment does not exist' do
        get '/api/scheduled_payments/-1',
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
          payment_amount: -7.0,
          date: '2020-10-01',
          description: 'new_scheduled_payment_text',
          loan_id: 2
        }
      end

      it 'updates the scheduled payment' do
        patch '/api/scheduled_payments/2',
              params: {
                user_id: 3,
                session_key: @session.key,
                payload: updated_attributes
              }

        expect(response).to be_successful

        scheduled_payment = ScheduledPayment.find(2)
        expect(scheduled_payment.payment_amount).to eq(-7.0)
        expect(scheduled_payment.description).to eq 'new_scheduled_payment_text'
      end

      it 'does not update scheduled payments of other users' do
        expect do
          patch '/api/scheduled_payments/1',
                params: {
                  user_id: 3,
                  session_key: @session.key,
                  payload: updated_attributes
                }

          expect(response).to have_http_status 403
        end.not_to change(ScheduledPayment.find(1), :description)
      end

      it 'shows forbidden if the scheduled payment does not exist' do
        patch '/api/scheduled_payments/-1',
              params: {
                user_id: 3,
                session_key: @session.key,
                payload: updated_attributes
              }

        expect(response).to have_http_status 403
      end
    end

    describe 'destroy' do
      it 'destroys the scheduled payment' do
        expect do
          delete '/api/scheduled_payments/2',
                 params: {
                   user_id: 3,
                   session_key: @session.key
                 }

          expect(response).to be_successful
        end.to change(ScheduledPayment, :count).by(-1)
      end

      it 'does not destroy scheduled payments of other users' do
        expect do
          delete '/api/scheduled_payments/1',
                 params: {
                   user_id: 3,
                   session_key: @session.key
                 }

          expect(response).to have_http_status 403
        end.not_to change(ScheduledPayment, :count)
      end

      it 'shows forbidden if the scheduled payment does not exist' do
        expect do
          delete '/api/scheduled_payments/-1',
                 params: {
                   user_id: 3,
                   session_key: @session.key
                 }
          expect(response).to have_http_status 403
        end.not_to change(ScheduledPayment, :count)
      end
    end
  end

  context 'Logged Out' do
    it 'index is locked' do
      get '/api/scheduled_payments'
      expect(response).to have_http_status 403
    end

    it 'create is locked' do
      expect do
        get '/api/scheduled_payments',
            params: {
              payload: valid_attributes
            }

        expect(response).to have_http_status 403
      end.not_to change(ScheduledPayment, :count)
    end

    it 'show is locked' do
      get '/api/scheduled_payments/1'
      expect(response).to have_http_status 403
    end

    it 'update is locked' do
      expect do
        patch '/api/scheduled_payments/1',
              params: {
                payload: valid_attributes
              }

        expect(response).to have_http_status 403
      end.not_to change(ScheduledPayment.find(1), :description)
    end

    it 'destroy is locked' do
      expect do
        delete '/api/scheduled_payments/1',
               params: {}

        expect(response).to have_http_status 403
      end.not_to change(ScheduledPayment, :count)
    end
  end
end
