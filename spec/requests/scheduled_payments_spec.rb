# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/scheduled_payments', type: :request do
  context 'Logged in' do
    before(:each) do
      post '/sessions/create', params: { username: 'Basic', password: '.test.' }
    end

    let(:valid_attributes) do
      {
        payment_amount: 5.0,
        date: '2021-04-09',
        description: 'scheduled_payment',
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
        ScheduledPayment.create! valid_attributes
        get scheduled_payments_url
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        scheduled_payment = ScheduledPayment.create! valid_attributes
        get scheduled_payment_url(scheduled_payment)
        expect(response).to be_successful
      end

      it 'redirects if scheduled payment does not exist' do
        get scheduled_payment_url(-1)
        expect(response).to be_redirect
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_scheduled_payment_url
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render a successful response' do
        scheduled_payment = ScheduledPayment.create! valid_attributes
        get edit_scheduled_payment_url(scheduled_payment)
        expect(response).to be_successful
      end

      it 'redirects if scheduled payment does not exist' do
        get edit_scheduled_payment_url(-1)
        expect(response).to be_redirect
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new ScheduledPayment' do
          expect do
            post scheduled_payments_url,
                 params: { scheduled_payment: valid_attributes }
          end.to change(ScheduledPayment, :count).by(1)
        end

        it 'redirects to the created scheduled_payment' do
          post scheduled_payments_url, params: { scheduled_payment: valid_attributes }
          expect(response).to redirect_to(scheduled_payment_url(ScheduledPayment.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new ScheduledPayment' do
          expect do
            post scheduled_payments_url,
                 params: { scheduled_payment: invalid_attributes }
          end.to change(ScheduledPayment, :count).by(0)
        end

        it 'renders a successful response (i.e. to display the \'new\' template)' do
          post scheduled_payments_url, params: { scheduled_payment: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          {
            payment_amount: -7.0,
            date: '2019-01-01',
            description: 'new_scheduled_payment_text',
            loan_id: 2
          }
        end

        it 'updates the requested scheduled_payment' do
          scheduled_payment = ScheduledPayment.create! valid_attributes
          patch scheduled_payment_url(scheduled_payment), params: { scheduled_payment: new_attributes }
          scheduled_payment.reload

          expect(scheduled_payment.payment_amount).to eq(-7.0)
          expect(scheduled_payment.description).to eq 'new_scheduled_payment_text'
        end

        it 'redirects back to the list if scheduled payment does not exist' do
          scheduled_payment = ScheduledPayment.create! valid_attributes
          patch scheduled_payment_url(-1), params: { scheduled_payment: new_attributes }
          scheduled_payment.reload

          expect(response).to be_redirect
          expect(scheduled_payment.description).not_to eq 'new_scheduled_payment_text'
        end

        it 'redirects to the scheduled_payment' do
          scheduled_payment = ScheduledPayment.create! valid_attributes
          patch scheduled_payment_url(scheduled_payment), params: { scheduled_payment: new_attributes }
          scheduled_payment.reload
          expect(response).to redirect_to(scheduled_payment_url(scheduled_payment))
        end
      end

      context 'with invalid parameters' do
        it 'renders a successful response (i.e. to display the \'edit\' template)' do
          scheduled_payment = ScheduledPayment.create! valid_attributes
          patch scheduled_payment_url(scheduled_payment), params: { scheduled_payment: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested scheduled_payment' do
        scheduled_payment = ScheduledPayment.create! valid_attributes
        expect { delete scheduled_payment_url(scheduled_payment) }.to change(ScheduledPayment, :count).by(-1)
      end

      it 'redirects to the scheduled_payments list' do
        scheduled_payment = ScheduledPayment.create! valid_attributes
        delete scheduled_payment_url(scheduled_payment)
        expect(response).to redirect_to(scheduled_payments_url)
      end

      it 'redirects to the scheduled payments list for non existing scheduled payments' do
        expect { delete scheduled_payment_url(-1) }.not_to change(ScheduledPayment, :count)
      end
    end
  end

  context 'Logged out' do
    describe 'GET index' do
      it 'redirects back to home#index' do
        get scheduled_payments_url
        expect(response).to be_redirect
      end
    end

    describe 'GET show' do
      it 'redirects back to home#index for existing scheduled payments-ids' do
        scheduled_payment = create :scheduled_payment

        get scheduled_payment_url(scheduled_payment)
        expect(response).to be_redirect
      end

      it 'redirects back to home#index for non-existing scheduled payments-ids' do
        get scheduled_payment_url(-1)
        expect(response).to be_redirect
      end
    end

    describe 'GET new' do
      it 'redirects back to home#index' do
        get new_scheduled_payment_url
        expect(response).to be_redirect
      end
    end

    describe 'GET edit' do
      it 'redirects back to home#index for existing scheduled payments-ids' do
        scheduled_payment = create :scheduled_payment

        get edit_scheduled_payment_url(scheduled_payment)
        expect(response).to be_redirect
      end

      it 'redirects back to home#index for non-existing scheduled payments-ids' do
        get edit_scheduled_payment_path(-1)
        expect(response).to be_redirect
      end
    end

    describe 'DELETE destroy' do
      it 'redirects back to home#index for existing scheduled payments-ids' do
        scheduled_payment = create :scheduled_payment

        expect do
          delete scheduled_payment_url(scheduled_payment)
          expect(response).to be_redirect
        end.not_to change(ScheduledPayment, :count)

        expect(ScheduledPayment.find(scheduled_payment.id)).not_to be_nil
      end

      it 'redirects back to home#index for non-existing scheduled payments-ids' do
        expect do
          delete scheduled_payment_url(-1)
          expect(response).to be_redirect
        end.not_to change(ScheduledPayment, :count)
      end
    end
  end

  context 'Other user' do
    before(:all) do
      # Log in as Basic and create a scheduled payment for someone else
      post '/sessions/create', params: { username: 'Basic', password: '.test.' }
      @scheduled_payment = create :scheduled_payment
    end

    describe 'GET show' do
      it 'redirects to scheduled payments#index if user tries to access other users scheduled payments' do
        get scheduled_payment_url(@scheduled_payment)
        expect(response).to be_redirect
      end
    end

    describe 'GET edit' do
      it 'redirects back to the form if the user id does not match' do
        get edit_scheduled_payment_url(@scheduled_payment)
        expect(response).to be_redirect
      end
    end

    describe 'DELETE destroy' do
      it 'redirects back to scheduled payments#index if user tries to delete other users scheduled payments' do
        expect do
          delete scheduled_payment_url(@scheduled_payment)
          expect(response).to be_redirect
        end.not_to change(ScheduledPayment, :count)

        expect(ScheduledPayment.find(@scheduled_payment.id)).not_to be_nil
      end
    end
  end
end
