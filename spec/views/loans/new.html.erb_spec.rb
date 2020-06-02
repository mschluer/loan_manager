# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'loans/new', type: :view do
  before(:each) do
    @loan = assign(:loan, build(:loan))
  end

  it 'renders new loan form' do
    render

    assert_select 'form[action=?][method=?]', loans_path, 'post' do
      assert_select 'input[name=?]', 'loan[name]'
      assert_select 'input[name=?]', 'loan[total_amount]'
      assert_select 'textarea[name=?]', 'loan[description]'
    end
  end
end
