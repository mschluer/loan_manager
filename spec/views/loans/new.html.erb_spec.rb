require 'rails_helper'

RSpec.describe "loans/new", type: :view do
  before(:each) do
    @person = create(:person)

    @loan = assign(:loan, Loan.new(
        name: "MyString",
        total_amount: 1.5,
        description: "MyText",
        date: '2020-04-09',
        person_id: @person.id
    ))
  end

  it "renders new loan form" do
    render

    assert_select "form[action=?][method=?]", loans_path, "post" do

      assert_select "input[name=?]", "loan[name]"

      assert_select "input[name=?]", "loan[total_amount]"

      assert_select "textarea[name=?]", "loan[description]"
    end
  end
end
