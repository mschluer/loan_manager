# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'people/show', type: :view do
  before(:each) do
    @person = assign(:person, create(:person,
                                     first_name: 'First Name',
                                     last_name: 'Last Name',
                                     phone_number: '49 174 1234 1234'))
  end

  it 'renders attributes in <p>' do
    render

    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/49 174 1234 1234/)
    expect(rendered).to match(/#{@person.user.username}/)
  end
end
