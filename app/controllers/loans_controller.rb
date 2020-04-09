class LoansController < ApplicationController
  before_action :redirect_to_index_if_not_logged_in
  before_action :set_loan, only: [:show, :edit, :update, :destroy]
  before_action :check_access_privilege, only: [:show, :edit, :update, :destroy]

  # GET /loans
  # GET /loans.json
  def index
    @loans = Loan.all
  end

  # GET /loans/1
  # GET /loans/1.json
  def show
  end

  # GET /loans/new
  def new
    @loan = Loan.new
    @list_of_people = Person.where(user_id: current_user).order(:first_name)
  end

  # GET /loans/1/edit
  def edit
    @list_of_people = Person.where(user_id: current_user).order(:first_name)
  end

  # POST /loans
  # POST /loans.json
  def create
    @loan = Loan.new(loan_params)

    respond_to do |format|
      if @loan.save
        format.html { redirect_to @loan, notice: 'Loan was successfully created.' }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loans/1
  # PATCH/PUT /loans/1.json
  def update
    respond_to do |format|
      if @loan.update(loan_params)
        format.html { redirect_to @loan, notice: 'Loan was successfully updated.' }
        format.json { render :show, status: :ok, location: @loan }
      else
        format.html { render :edit }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loans/1
  # DELETE /loans/1.json
  def destroy
    @loan.destroy
    respond_to do |format|
      format.html { redirect_to loans_url, notice: 'Loan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_loan
    @loan = Loan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def loan_params
    params.require(:loan).permit(:name, :total_amount, :date, :description, :person_id)
  end

  def check_access_privilege
    if @loan.person.user != current_user
      respond_to do |format|
        format.html { redirect_to home_dashboard_path, notice: 'Loan not accessible for this User' }
        format.json { header :forbidden }
      end
    end
  end
end
