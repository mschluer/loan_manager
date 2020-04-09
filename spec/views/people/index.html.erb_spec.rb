require 'rails_helper'

RSpec.describe "people/index", type: :view do
  before(:each) do
    @user = create(:user)

    assign(:people, [
      Person.create!(
        first_name: "First Name",
        last_name: "Last Name",
        phone_number: "Phone Number",
        user_id: @user.id
      ),
      Person.create!(
        first_name: "First Name",
        last_name: "Last Name",
        phone_number: "Phone Number",
        user_id: @user.id
      )
    ])
  end

  it "renders a list of people" do
    render
    assert_select "tr>td", text: "First Name".to_s, count: 2
    assert_select "tr>td", text: "Last Name".to_s, count: 2
    assert_select "tr>td", text: "Phone Number".to_s, count: 2
  end
end
