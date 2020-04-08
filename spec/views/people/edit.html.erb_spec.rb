require 'rails_helper'

RSpec.describe "people/edit", type: :view do
  before(:each) do
    @user = create(:user)

    @person = assign(:person, Person.create!(
      first_name: "MyString",
      last_name: "MyString",
      phone_number: "MyString",
      user_id: @user.id
    ))
  end

  it "renders the edit person form" do
    render

    assert_select "form[action=?][method=?]", person_path(@person), "post" do

      assert_select "input[name=?]", "person[first_name]"

      assert_select "input[name=?]", "person[last_name]"

      assert_select "input[name=?]", "person[phone_number]"
    end
  end
end
