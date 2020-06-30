# frozen_string_literal: true

module Api
  class ScheduledPaymentsController < Api::ApiBaseController
    before_action :set_scheduled_payment, only: %i[show update destroy]
    before_action :check_access_privilege, only: %i[show update destroy]

    # GET /api/scheduled_payments
    def index
      person_ids = Person.where(user_id: current_user.id).pluck(:id)
      loan_ids = Loan.where(person_id: person_ids).pluck(:id)

      render json: ScheduledPayment.where(loan_id: loan_ids), status: :ok
    end

    # POST /api/scheduled_payments
    def create
      @scheduled_payment = ScheduledPayment.new(scheduled_payment_params)

      if @scheduled_payment.save
        render json: @scheduled_payment, status: :created
      else
        respond_with_bad_request
      end
    end

    # GET /api/scheduled_payments/1
    def show
      render json: @scheduled_payment, status: :ok
    end

    # PATCH/PUT /api/scheduled_payments/1
    def update
      if @scheduled_payment.update(scheduled_payment_params)
        render json: @scheduled_payment, status: :ok
      else
        respond_with_bad_request
      end
    end

    # DELETE /api/scheduled_payments/1
    def destroy
      @scheduled_payment.destroy
      render json: {}, status: :no_content
    end

    private

    def set_scheduled_payment
      @scheduled_payment = ScheduledPayment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_with_forbidden
    end

    def scheduled_payment_params
      params.require(:payload).permit(:payment_amount, :date, :description, :loan_id)
    end

    def check_access_privilege
      return if @scheduled_payment.loan.person.user == current_user

      respond_with_forbidden
    end
  end
end
