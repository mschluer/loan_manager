require 'rails_helper'

RSpec.describe "scheduled_payments/edit", type: :view do
  before(:each) do
    @loan = create(:loan)

    @scheduled_payment = assign(:scheduled_payment, ScheduledPayment.create!(
      payment_amount: 1.5,
      date: "2021-01-01",
      description: "MyText",
      loan_id: @loan.id
    ))
  end

  it "renders the edit scheduled_payment form" do
    render

    assert_select "form[action=?][method=?]", scheduled_payment_path(@scheduled_payment), "post" do
      assert_select 'input[name=?]', 'scheduled_payment[payment_amount]'

      assert_select 'select[id=?]', 'scheduled_payment_date_1i'
      assert_select 'select[id=?]', 'scheduled_payment_date_2i'
      assert_select 'select[id=?]', 'scheduled_payment_date_3i'

      assert_select 'textarea[name=?]', 'scheduled_payment[description]'
    end
  end
end
