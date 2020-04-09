require 'rails_helper'

RSpec.describe "payments/edit", type: :view do
  before(:each) do
    @user = create(:user)

    @person = build(:person)
    @person.user = @user
    @person.save

    @loan = build(:loan)
    @loan.person = @person
    @loan.save

    @payment = assign(:payment, Payment.create!(
      payment_amount: 1.5,
      description: "MyText",
      date: '2020-04-09',
      loan_id: @loan.id
    ))
  end

  it "renders the edit payment form" do
    render

    assert_select "form[action=?][method=?]", payment_path(@payment), "post" do

      assert_select "input[name=?]", "payment[payment_amount]"

      assert_select "textarea[name=?]", "payment[description]"
    end
  end
end
