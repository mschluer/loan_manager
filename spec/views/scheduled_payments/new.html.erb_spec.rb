require 'rails_helper'

RSpec.describe "scheduled_payments/new", type: :view do
  before(:each) do
    assign(:scheduled_payment, ScheduledPayment.new(
      payment_amount: 1.5,
      date: "2021-01-01",
      description: "Scheduled Payment Text",
      loan_id: 1
    ))
  end

  it "renders new scheduled_payment form" do
    render

    assert_select "form[action=?][method=?]", scheduled_payments_path, "post" do

      assert_select "input[name=?]", "scheduled_payment[payment_amount]"

      assert_select "input[name=?]", "scheduled_payment[date]"

      assert_select "input[name=?]", "scheduled_payment[description]"

      assert_select "input[name=?]", "scheduled_payment[loan_id]"
    end
  end
end
