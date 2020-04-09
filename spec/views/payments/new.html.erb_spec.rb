require 'rails_helper'

RSpec.describe "payments/new", type: :view do
  before(:each) do
    assign(:payment, Payment.new(
      payment_amount: 1.5,
      description: "MyText"
    ))
  end

  it "renders new payment form" do
    render

    assert_select "form[action=?][method=?]", payments_path, "post" do

      assert_select "input[name=?]", "payment[payment_amount]"

      assert_select "textarea[name=?]", "payment[description]"
    end
  end
end
