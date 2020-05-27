# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'people/new', type: :view do
  before(:each) do
    assign(:person, build(:person))
  end

  it 'renders new person form' do
    render

    assert_select 'form[action=?][method=?]', people_path, 'post' do
      assert_select 'input[name=?]', 'person[first_name]'
      assert_select 'input[name=?]', 'person[last_name]'
      assert_select 'input[name=?]', 'person[phone_number]'
    end
  end
end
