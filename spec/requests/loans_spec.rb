# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/loans', type: :request do
  context 'Logged in' do
    before(:each) do
      post '/sessions/create', params: { username: 'Basic', password: '.test.' }
    end

    let(:valid_attributes) do
      {
        name: 'valid_name',
        total_amount: 5,
        date: '2020-04-08',
        description: 'Description',
        person_id: 2
      }
    end

    let(:invalid_attributes) do
      {
        name: '',
        total_amount: 5,
        date: '',
        description: 'Description',
        person_id: nil
      }
    end

    describe 'GET /index' do
      it 'renders a successful response' do
        Loan.create! valid_attributes
        get loans_url
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        loan = Loan.create! valid_attributes
        get loan_url(loan)
        expect(response).to be_successful
      end

      it 'redirects if loan does not exist' do
        get loan_url(-1)

        expect(response).not_to be_successful
        expect(response).to be_redirect
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_loan_url
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'renders a successful response' do
        loan = Loan.create! valid_attributes
        get edit_loan_url(loan)
        expect(response).to be_successful
      end

      it 'redirects if loan does not exist' do
        get edit_loan_url(-1)

        expect(response).not_to be_successful
        expect(response).to be_redirect
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new Loan' do
          expect { post loans_url, params: { loan: valid_attributes } }.to change(Loan, :count).by(1)
        end

        it 'redirects to the created loan' do
          post loans_url, params: { loan: valid_attributes }
          expect(response).to redirect_to(loan_url(Loan.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Loan' do
          expect { post loans_url, params: { loan: invalid_attributes } }.to change(Loan, :count).by(0)
        end

        it 'renders a successful response (i.e. to display the \'new\' template)' do
          post loans_url, params: { loan: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          {
            name: 'NewName',
            total_amount: '10',
            date: '2020-10-04',
            description: 'NewDescription',
            person_id: 2
          }
        end

        it 'updates the requested loan' do
          loan = Loan.create! valid_attributes
          patch loan_url(loan), params: { loan: new_attributes }
          loan.reload

          expect(loan.name).to eq 'NewName'
          expect(loan.total_amount).to eq 10
          expect(loan.description).to eq 'NewDescription'
        end

        it 'redirects back to the list if loan does not exist' do
          loan = Loan.create! valid_attributes
          patch loan_url(-1), params: { loan: new_attributes }
          loan.reload

          expect(response).to be_redirect
          expect(loan.name).to eq 'valid_name'
        end

        it 'redirects to the loan' do
          loan = Loan.create! valid_attributes
          patch loan_url(loan), params: { loan: new_attributes }
          loan.reload
          expect(response).to redirect_to(loan_url(loan))
        end
      end

      context 'with invalid parameters' do
        it 'renders a successful response (i.e. to display the \'edit\' template)' do
          loan = Loan.create! valid_attributes
          patch loan_url(loan), params: { loan: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested loan' do
        loan = Loan.create! valid_attributes
        expect { delete loan_url(loan) }.to change(Loan, :count).by(-1)
      end

      it 'redirects to the loans list' do
        loan = Loan.create! valid_attributes
        delete loan_url(loan)
        expect(response).to redirect_to(loans_url)
      end

      it 'redirects to the loans list for non existing loans' do
        expect { delete loan_url(-1) }.not_to change(Loan, :count)
      end
    end
  end

  context 'Logged out' do
    describe 'GET index' do
      it 'redirects back to home#index' do
        get loans_url

        expect(response).to be_redirect
      end
    end

    describe 'GET show' do
      it 'redirects back to home#index for existing loan-ids' do
        loan = create :loan

        get loan_url(loan)

        expect(response).to be_redirect
      end

      it 'redirects back to home#index for non-existing loan-ids' do
        get loan_url(-1)

        expect(response).to be_redirect
      end
    end

    describe 'GET new' do
      it 'redirects back to home#index' do
        get new_loan_url

        expect(response).to be_redirect
      end
    end

    describe 'GET edit' do
      it 'redirects back to home#index for existing loan-ids' do
        loan = create :loan

        get edit_loan_url(loan)

        expect(response).to be_redirect
      end

      it 'redirects back to home#index for non-existing loan-ids' do
        get edit_loan_url(-1)

        expect(response).to be_redirect
      end
    end

    describe 'DELETE destroy' do
      it 'redirects back to home#index for existing loan-ids' do
        loan = create :loan

        expect do
          delete loan_url(loan)

          expect(response).to be_redirect
        end.not_to change(Loan, :count)

        expect(Loan.find(loan.id)).not_to be_nil
      end

      it 'redirects back to home#index for non-existing loan-ids' do
        expect do
          delete loan_url(-1)
          expect(response).to be_redirect
        end.not_to change(Loan, :count)
      end
    end
  end

  context 'Other user' do
    before(:all) do
      # Log in as Basic and Create a Loan for someone else
      post '/sessions/create', params: { username: 'Basic', password: '.test.' }
      @loan = create :loan
    end

    describe 'GET show' do
      it 'redirects to loan#index if user tries to access other users loan' do
        get loan_url(@loan)

        expect(response).to be_redirect
      end
    end

    describe 'GET edit' do
      it 'redirects back to the form if the user id does not match' do
        get edit_loan_url(@loan)

        expect(response).to be_redirect
      end
    end

    describe 'DELETE destroy' do
      it 'redirects back to loan#index if user tries to delete other users loan' do
        expect do
          delete loan_url(@loan)
          expect(response).to be_redirect
        end.not_to change(Loan, :count)

        expect(Loan.find(@loan.id)).not_to be_nil
      end
    end
  end
end
