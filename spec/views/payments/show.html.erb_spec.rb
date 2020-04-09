require 'rails_helper'

RSpec.describe "payments/show", type: :view do
  before(:each) do
    @user = create(:user)

    @person = build(:person)
    @person.user = @user
    @person.save

    @loan = build(:loan)
    @loan.person = @person
    @loan.save

    @payment = assign(:payment, Payment.create!(
      payment_amount: 2.5,
      description: "MyText",
      date: '2020-04-09',
      loan_id: @loan.id
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/MyText/)
  end
end
