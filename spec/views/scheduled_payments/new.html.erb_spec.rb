# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'scheduled_payments/new', type: :view do
  before(:each) do
    assign(:scheduled_payment, build(:scheduled_payment))
  end

  it 'renders new scheduled_payment form' do
    render

    assert_select 'form[action=?][method=?]', scheduled_payments_path, 'post' do
      assert_select 'input[name=?]', 'scheduled_payment[payment_amount]'

      assert_select 'select[id=?]', 'scheduled_payment_date_1i'
      assert_select 'select[id=?]', 'scheduled_payment_date_2i'
      assert_select 'select[id=?]', 'scheduled_payment_date_3i'

      assert_select 'textarea[name=?]', 'scheduled_payment[description]'
    end
  end
end
