require 'rails_helper'

RSpec.describe "payments/index", type: :view do
  before(:each) do
    @loan = create(:loan)

    assign(:payments, [
      Payment.create!(
        payment_amount: 2.5,
        description: "MyText",
        date: '2020-04-09',
        loan_id: @loan.id
      ),
      Payment.create!(
        payment_amount: 2.5,
        description: "MyText",
        date: '2020-04-09',
        loan_id: @loan.id
      )
    ])
  end

  it "renders a list of payments" do
    render
    assert_select "tr>td", text: 2.5.to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
