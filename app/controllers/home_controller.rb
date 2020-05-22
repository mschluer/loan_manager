class HomeController < ApplicationController
  skip_before_action :redirect_to_index_if_not_logged_in, only: :index
  def index
    if current_user
      respond_to do |format|
        format.html { redirect_to home_dashboard_path }
        format.json { head :no_content }
      end
    end
  end

  def dashboard
    @people = Person.where(user_id: current_user.id)
    @loans = Loan.where(person_id: @people)

    @current_outstanding_balance = 0
    @active_and_negative_loans = []
    @active_and_positive_loans = []

    @loans.each do |loan|
      if loan.balance != 0
        @current_outstanding_balance += loan.balance
        if loan.balance > 0
          @active_and_positive_loans.unshift loan
        else
          @active_and_negative_loans.unshift loan
        end
      end
    end

    @active_loans_amount = @active_and_negative_loans.size + @active_and_positive_loans.size
    @paid_loans_amount = @loans.count - @active_loans_amount

    @most_recent_payments = Payment.where(loan_id: @loans).limit(10).order(id: :desc)
  end
end
