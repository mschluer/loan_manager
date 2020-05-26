require 'rails_helper'

RSpec.describe "scheduled_payments/show", type: :view do
  before(:each) do
    @scheduled_payment = assign(:scheduled_payment, ScheduledPayment.create!(
      payment_amount: 1.5,
      date: "2021-01-01",
      description: "Scheduled Payment Text",
      loan_id: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
  end
end
