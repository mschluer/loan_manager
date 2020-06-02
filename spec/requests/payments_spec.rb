# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/payments', type: :request do
  context 'Logged in' do
    before(:each) do
      post '/sessions/create', params: { username: 'Basic', password: '.test.' }
    end

    let(:valid_attributes) do
      {
        payment_amount: 5.0,
        date: '2020-04-09',
        description: 'payment_text',
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

    describe 'GET /index' do
      it 'renders a successful response' do
        Payment.create! valid_attributes
        get payments_url
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        payment = Payment.create! valid_attributes
        get payment_url(payment)
        expect(response).to be_successful
      end

      it 'redirects is payment does not exist' do
        get payment_url(-1)
        expect(response).to be_redirect
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_payment_url
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render a successful response' do
        payment = Payment.create! valid_attributes
        get edit_payment_url(payment)
        expect(response).to be_successful
      end

      it 'redirects if payment does not exist' do
        get edit_payment_url(-1)
        expect(response).to be_redirect
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new Payment' do
          expect { post payments_url, params: { payment: valid_attributes } }.to change(Payment, :count).by(1)
        end

        it 'redirects to the created payment' do
          post payments_url, params: { payment: valid_attributes }
          expect(response).to redirect_to(payment_url(Payment.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Payment' do
          expect { post payments_url, params: { payment: invalid_attributes } }.to change(Payment, :count).by(0)
        end

        it 'renders a successful response (i.e. to display the \'new\' template)' do
          post payments_url, params: { payment: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          {
            payment_amount: -7.0,
            date: '2020-10-01',
            description: 'new_payment_text',
            loan_id: 2
          }
        end

        it 'updates the requested payment' do
          payment = Payment.create! valid_attributes
          patch payment_url(payment), params: { payment: new_attributes }
          payment.reload

          expect(payment.payment_amount).to eq(-7.0)
          expect(payment.description).to eq 'new_payment_text'
        end

        it 'redirects back to the list if payment does not exist' do
          patch payment_url(-1), params: { payment: new_attributes }
          expect(response).to be_redirect
        end

        it 'redirects to the payment' do
          payment = Payment.create! valid_attributes
          patch payment_url(payment), params: { payment: new_attributes }
          payment.reload
          expect(response).to redirect_to(payment_url(payment))
        end
      end

      context 'with invalid parameters' do
        it 'renders a successful response (i.e. to display the \'edit\' template)' do
          payment = Payment.create! valid_attributes
          patch payment_url(payment), params: { payment: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested payment' do
        payment = Payment.create! valid_attributes
        expect { delete payment_url(payment) }.to change(Payment, :count).by(-1)
      end

      it 'redirects to the payments list' do
        payment = Payment.create! valid_attributes
        delete payment_url(payment)
        expect(response).to redirect_to(payments_url)
      end

      it 'redirects to the payments list for non existing payments' do
        expect do
          delete payment_url(-1)
          expect(response).to be_redirect
        end.not_to change(Payment, :count)
      end
    end
  end

  context 'Logged out' do
    describe 'GET index' do
      it 'redirects back to home#index' do
        get payments_url
        expect(response).to be_redirect
      end
    end

    describe 'GET show' do
      it 'redirects back to home#index for existing payment-ids' do
        payment = create :payment
        get payment_url(payment)
        expect(response).to be_redirect
      end

      it 'redirects back to home#index for non-existing payment-ids' do
        get payment_url(-1)
        expect(response).to be_redirect
      end
    end

    describe 'GET new' do
      it 'redirects back to home#index' do
        get new_payment_url
        expect(response).to be_redirect
      end
    end

    describe 'GET edit' do
      it 'redirects back to home#index for existing payment-ids' do
        payment = create :payment
        get edit_payment_url(payment)
        expect(response).to be_redirect
      end

      it 'redirects back to home#index for non-existing payment-ids' do
        get edit_payment_url(-1)
        expect(response).to be_redirect
      end
    end

    describe 'DELETE destroy' do
      it 'redirects back to home#index for existing payment-ids' do
        payment = create :payment

        expect do
          delete payment_url(payment)
          expect(response).to be_redirect
        end.not_to change(Payment, :count)

        expect(Payment.find(payment.id)).not_to be_nil
      end

      it 'redirects back to home#index for non-existing payment-ids' do
        expect do
          delete payment_url(-1)
          expect(response).to be_redirect
        end.not_to change(Payment, :count)
      end
    end
  end

  context 'Other user' do
    before(:all) do
      # Log in as Basic and Create a Payment for someone else
      post '/sessions/create', params: { username: 'Basic', password: '.test.' }
      @payment = create :payment
    end

    describe 'GET show' do
      it 'redirects to payment#index if user tries to access other users payment' do
        get payment_url(@payment)
        expect(response).to be_redirect
      end
    end

    describe 'GET edit' do
      it 'redirects back to the form if the user id does not match' do
        get edit_payment_url(@payment)
        expect(response).to be_redirect
      end
    end

    describe 'DELETE destroy' do
      it 'redirects back to payment#index if user tries to delete other users payment' do
        expect do
          delete payment_url(@payment)
          expect(response).to be_redirect
        end.not_to change(Payment, :count)

        expect(Payment.find(@payment.id)).not_to be_nil
      end
    end
  end
end
