require 'rails_helper'

RSpec.describe "loans/show", type: :view do
  before(:each) do
    @user = create(:user)

    @person = build(:person)
    @person.user = @user
    @person.save

    @loan = assign(:loan, Loan.create!(
        name: "MyString",
        total_amount: 2.5,
        description: "MyText",
        date: '2020-04-09',
        person_id: @person.id
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyString/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2020-04-09/)
    expect(rendered).to match(/#{@person.full_name}/)
    expect(rendered).to match(/#{@person.user.username}/)
    expect(rendered).to match(/Account Statement/)
  end
end
