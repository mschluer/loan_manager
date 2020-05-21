require 'rails_helper'

RSpec.describe "sessions/new.html.erb", type: :view do
  it 'renders the new session form' do
    render

    assert_select "form[action=?][method=?]", sessions_create_path, "post" do
      assert_select "input[name=?]", "username"
      assert_select "input[type=?][name=?]", "password", "password"
    end
  end
end
