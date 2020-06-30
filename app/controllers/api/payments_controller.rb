# frozen_string_literal: true

module Api
  class PaymentsController < Api::ApiBaseController
    before_action :set_payment, only: %i[show update destroy]
    before_action :check_access_privilege, only: %i[show update destroy]

    # GET /api/payments
    def index
      person_ids = Person.where(user_id: current_user.id).pluck(:id)
      loan_ids = Loan.where(person_id: person_ids).pluck(:id)

      render json: Payment.where(loan_id: loan_ids), status: :ok
    end

    # POST /api/payments
    def create
      @payment = Payment.new(payment_params)

      if @payment.save
        render json: @payment, status: :created
      else
        respond_with_bad_request
      end
    end

    # GET /api/payments/1
    def show
      render json: @payment, status: :ok
    end

    # PATCH/PUT /api/payments/1
    def update
      if @payment.update(payment_params)
        render json: @payment, status: :ok
      else
        respond_with_bad_request
      end
    end

    # DELETE /api/payments/1
    def destroy
      @payment.destroy
      render json: {}, status: :no_content
    end

    private

    def set_payment
      @payment = Payment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_with_forbidden
    end

    def payment_params
      params.require(:payload).permit(:payment_amount, :date, :description, :loan_id)
    end

    def check_access_privilege
      return if @payment.loan.person.user == current_user

      respond_with_forbidden
    end
  end
end
