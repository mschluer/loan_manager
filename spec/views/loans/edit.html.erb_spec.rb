# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'loans/edit', type: :view do
  before(:each) do
    @loan = assign(:loan, create(:loan))
  end

  it 'renders the edit loan form' do
    render

    assert_select 'form[action=?][method=?]', loan_path(@loan), 'post' do
      assert_select 'input[name=?]', 'loan[name]'
      assert_select 'input[name=?]', 'loan[total_amount]'
      assert_select 'textarea[name=?]', 'loan[description]'
    end
  end
end
