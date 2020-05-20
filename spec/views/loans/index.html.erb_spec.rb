require 'rails_helper'

RSpec.describe "loans/index", type: :view do
  before(:each) do
    @user = create(:user)

    @person = build(:person)
    @person.user = @user
    @person.save

    assign(:loans, [
      Loan.create!(
        name: "Name",
        total_amount: 2.5,
        description: "MyText",
        date: '2020-04-09',
        person_id: @person.id
      ),
      Loan.create!(
        name: "Name",
        total_amount: 2.5,
        description: "MyText",
        date: '2020-04-09',
        person_id: @person.id
      )
    ])
  end

  it "renders a list of loans" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: 2.5.to_s, count: 4 # 2 for Total amount + 2 for Balance
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
