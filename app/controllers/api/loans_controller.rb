# frozen_string_literal: true

module Api
  class LoansController < Api::ApiBaseController
    before_action :set_loan, only: %i[show update destroy]
    before_action :check_access_privilege, only: %i[show update destroy]

    # POST /api/loans
    def index
      list_of_person_ids = Person.where(user_id: current_user.id).pluck(:id)
      render json: Loan.where(person_id: list_of_person_ids), status: :ok
    end

    # POST /api/loans
    def create
      @loan = Loan.new(loan_params)

      if @loan.save
        render json: @loan, status: :created
      else
        respond_with_bad_request
      end
    end

    # POST /api/loans/1
    def show
      render json: {
        loan: @loan,
        payments: @loan.payments,
        scheduled_payments: @loan.scheduled_payments
      }, status: :ok
    end

    # PATCH/PUT /api/loans/1
    def update
      if @loan.update(loan_params)
        render json: @loan, status: :ok
      else
        respond_with_bad_request
      end
    end

    # DESTROY /api/loans/1
    def destroy
      @loan.destroy
      render json: {}, status: :no_content
    end

    private

    def set_loan
      @loan = Loan.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_with_forbidden
    end

    def loan_params
      params.require(:payload).permit(:name, :total_amount, :date, :description, :person_id)
    end

    def check_access_privilege
      return if @loan.person.user == current_user

      respond_with_forbidden
    end
  end
end
