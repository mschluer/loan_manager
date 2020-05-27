# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :redirect_to_index_if_not_logged_in, only: :index
  def index
    if current_user
      respond_to do |format|
        format.html { redirect_to home_dashboard_path }
        format.json { head :no_content }
      end
    end

    @number_of_users = User.count
    @number_of_people = Person.count
    @number_of_loans = Loan.count
    @number_of_payments = Payment.count
  end

  def dashboard
    @people = Person.where(user_id: current_user.id)
    @loans = Loan.where(person_id: @people)

    @current_outstanding_balance = 0
    @active_and_negative_loans = []
    @active_and_positive_loans = []

    @loans.each do |loan|
      next if loan.balance != 0

      @current_outstanding_balance += loan.balance
      if loan.balance.positive?
        @active_and_positive_loans.unshift loan
      else
        @active_and_negative_loans.unshift loan
      end
    end

    @active_loans_amount = @active_and_negative_loans.size + @active_and_positive_loans.size
    @paid_loans_amount = @loans.count - @active_loans_amount

    @most_recent_payments = Payment.where(loan_id: @loans).limit(10).order(id: :desc)
    @upcoming_payments = ScheduledPayment.where(loan_id: @loans).limit(10).order(date: :asc)
  end
end
