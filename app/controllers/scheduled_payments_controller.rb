class ScheduledPaymentsController < ApplicationController
  before_action :set_scheduled_payment, only: [:show, :edit, :update, :destroy]

  # GET /scheduled_payments
  # GET /scheduled_payments.json
  def index
    list_of_person_ids = Person.where(user_id: current_user).pluck(:id)
    list_of_loan_ids = Loan.where(person_id: list_of_person_ids).pluck(:id)
    @scheduled_payments = ScheduledPayment.where(loan_id: list_of_loan_ids)
  end

  # GET /scheduled_payments/1
  # GET /scheduled_payments/1.json
  def show
  end

  # GET /scheduled_payments/new
  def new
    @scheduled_payment = ScheduledPayment.new
    @scheduled_payment.loan_id = params[:loan_id]

    list_of_person_ids = Person.where(user_id: current_user).pluck(:id)
    @list_of_loans = Loan.where(person_id: list_of_person_ids).order(:name)

    if !params[:loan_id].nil?
      @selected_loan = @list_of_loans.detect { |loan| String(loan.id) == params[:loan_id] }

      if @selected_loan.nil?
        @selected_loan = @list_of_loans.first
      end
    end
  end

  # GET /scheduled_payments/1/edit
  def edit
    list_of_person_ids = Person.where(user_id: current_user).pluck(:id)
    @list_of_loans = Loan.where(person_id: list_of_person_ids).order(:name)
  end

  # POST /scheduled_payments
  # POST /scheduled_payments.json
  def create
    @scheduled_payment = ScheduledPayment.new(scheduled_payment_params)

    respond_to do |format|
      if @scheduled_payment.save
        format.html { redirect_to @scheduled_payment, notice: 'Scheduled payment was successfully created.' }
        format.json { render :show, status: :created, location: @scheduled_payment }
      else
        format.html { render :new }
        format.json { render json: @scheduled_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scheduled_payments/1
  # PATCH/PUT /scheduled_payments/1.json
  def update
    respond_to do |format|
      if @scheduled_payment.update(scheduled_payment_params)
        format.html { redirect_to @scheduled_payment, notice: 'Scheduled payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @scheduled_payment }
      else
        format.html { render :edit }
        format.json { render json: @scheduled_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scheduled_payments/1
  # DELETE /scheduled_payments/1.json
  def destroy
    @scheduled_payment.destroy
    respond_to do |format|
      format.html { redirect_to scheduled_payments_url, notice: 'Scheduled payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scheduled_payment
      @scheduled_payment = ScheduledPayment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def scheduled_payment_params
      params.require(:scheduled_payment).permit(:payment_amount, :date, :description, :loan_id)
    end
end
