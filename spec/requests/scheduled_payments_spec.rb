 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/scheduled_payments", type: :request do
  before(:each) do
    post '/sessions/create', params: { username: 'Basic', password: '.test.' }
  end

  let(:valid_attributes) { {
      payment_amount: 5.0,
      date: '2021-04-09',
      description: 'scheduled_payment',
      loan_id: 2
    }
  }

  let(:invalid_attributes) { {
      payment_amount: nil,
      date: nil,
      description: nil,
      loan_id: 2
    }
  }

  describe "GET /index" do
    it "renders a successful response" do
      ScheduledPayment.create! valid_attributes
      get scheduled_payments_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      scheduled_payment = ScheduledPayment.create! valid_attributes
      get scheduled_payment_url(scheduled_payment)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_scheduled_payment_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      scheduled_payment = ScheduledPayment.create! valid_attributes
      get edit_scheduled_payment_url(scheduled_payment)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new ScheduledPayment" do
        expect {
          post scheduled_payments_url, params: { scheduled_payment: valid_attributes }
        }.to change(ScheduledPayment, :count).by(1)
      end

      it "redirects to the created scheduled_payment" do
        post scheduled_payments_url, params: { scheduled_payment: valid_attributes }
        expect(response).to redirect_to(scheduled_payment_url(ScheduledPayment.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new ScheduledPayment" do
        expect {
          post scheduled_payments_url, params: { scheduled_payment: invalid_attributes }
        }.to change(ScheduledPayment, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post scheduled_payments_url, params: { scheduled_payment: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { {
          payment_amount: -7.0,
          date: '2019-01-01',
          description: 'new_scheduled_payment_text',
          loan_id: 2
        }
      }

      it "updates the requested scheduled_payment" do
        scheduled_payment = ScheduledPayment.create! valid_attributes
        patch scheduled_payment_url(scheduled_payment), params: { scheduled_payment: new_attributes }
        scheduled_payment.reload

        expect(scheduled_payment.payment_amount).to eq -7.0
        expect(scheduled_payment.description).to eq 'new_scheduled_payment_text'
      end

      it "redirects to the scheduled_payment" do
        scheduled_payment = ScheduledPayment.create! valid_attributes
        patch scheduled_payment_url(scheduled_payment), params: { scheduled_payment: new_attributes }
        scheduled_payment.reload
        expect(response).to redirect_to(scheduled_payment_url(scheduled_payment))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        scheduled_payment = ScheduledPayment.create! valid_attributes
        patch scheduled_payment_url(scheduled_payment), params: { scheduled_payment: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested scheduled_payment" do
      scheduled_payment = ScheduledPayment.create! valid_attributes
      expect {
        delete scheduled_payment_url(scheduled_payment)
      }.to change(ScheduledPayment, :count).by(-1)
    end

    it "redirects to the scheduled_payments list" do
      scheduled_payment = ScheduledPayment.create! valid_attributes
      delete scheduled_payment_url(scheduled_payment)
      expect(response).to redirect_to(scheduled_payments_url)
    end
  end
end