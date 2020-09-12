# frozen_string_literal: true

class ScheduledPaymentsController < ApplicationController
  before_action :set_scheduled_payment, only: %i[show edit update destroy check check_confirm]
  before_action :check_access_privilege, only: %i[show edit update destroy]

  # GET /scheduled_payments
  # GET /scheduled_payments.json
  def index
    @scheduled_payments = fetch_scheduled_payments
  end

  # GET /scheduled_payments/1
  # GET /scheduled_payments/1.json
  def show; end

  # GET /scheduled_payments/new
  def new
    @scheduled_payment = ScheduledPayment.new
    @scheduled_payment.loan_id = params[:loan_id]

    list_of_person_ids = Person.where(user_id: current_user).pluck(:id)
    @list_of_loans = Loan.where(person_id: list_of_person_ids).order(:name)

    return unless params[:loan_id].nil?

    @selected_loan = @list_of_loans.detect { |loan| String(loan.id) == params[:loan_id] }

    @selected_loan = @list_of_loans.first if @selected_loan.nil?
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

  # GET /scheduled_payments/1/check
  def check; end

  # POST /scheduled_payments/1/check_confirm
  def check_confirm
    @payment = Payment.new(scheduled_payment_params)

    respond_to do |format|
      if @payment.valid? && @payment.loan.person.user != current_user
        # Check Permission
        format.html { redirect_to home_dashboard_path, notice: 'Permission denied.' }
        format.json { head :forbidden }
      elsif @payment.save
        format.html { redirect_to home_dashboard_path, notice: 'Scheduled payment checked - Payment created.' }
        format.json { render show, status: :ok, location: @payment }

        @scheduled_payment.destroy
      else
        format.html { render :check }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /scheduled_payments/overdues
  def overdues
    @scheduled_payments = fetch_scheduled_payments.select(&:overdue?)

    respond_to do |format|
      format.html { render :overdues }
      format.json { @scheduled_payments }
    end
  end

  private

  def set_scheduled_payment
    @scheduled_payment = ScheduledPayment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to scheduled_payments_path, notice: 'Permission denied.' }
      format.json { head :forbidden }
    end
  end

  # Only allow a list of trusted parameters through.
  def scheduled_payment_params
    params.require(:scheduled_payment).permit(:payment_amount, :date, :description, :loan_id)
  end

  def check_access_privilege
    return if @scheduled_payment.loan.person.user == current_user

    respond_to do |format|
      format.html { redirect_to home_dashboard_path, notice: 'Access denied.' }
      format.json { header :forbidden }
    end
  end

  def fetch_scheduled_payments
    list_of_person_ids = Person.where(user_id: current_user).pluck(:id)
    list_of_loan_ids = Loan.where(person_id: list_of_person_ids).pluck(:id)
    ScheduledPayment.where(loan_id: list_of_loan_ids)
  end
end
