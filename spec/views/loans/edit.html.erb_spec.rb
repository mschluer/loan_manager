require 'rails_helper'

RSpec.describe "loans/edit", type: :view do
  before(:each) do
    @user = create(:user)

    @person = build(:person)
    @person.user = @user
    @person.save

    @loan = assign(:loan, Loan.create!(
      name: "MyString",
      total_amount: 1.5,
      description: "MyText",
      date: '2020-04-09',
      person_id: @person.id
    ))
  end

  it "renders the edit loan form" do
    render

    assert_select "form[action=?][method=?]", loan_path(@loan), "post" do

      assert_select "input[name=?]", "loan[name]"

      assert_select "input[name=?]", "loan[total_amount]"

      assert_select "textarea[name=?]", "loan[description]"
    end
  end
end
