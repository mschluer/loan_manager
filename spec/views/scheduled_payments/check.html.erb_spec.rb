# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'scheduled_payments/check', type: :view do
  before(:each) do
    @scheduled_payment = assign(:scheduled_payment, create(:scheduled_payment))
  end

  it 'renders the check scheduled payment form' do
    render

    assert_select 'form[action=?][method=?]', check_confirm_scheduled_payment_path(@scheduled_payment), 'post' do
      assert_select 'input[name=?]', 'scheduled_payment[payment_amount]'

      assert_select 'select[id=?]', 'scheduled_payment_date_1i'
      assert_select 'select[id=?]', 'scheduled_payment_date_2i'
      assert_select 'select[id=?]', 'scheduled_payment_date_3i'

      assert_select 'textarea[name=?]', 'scheduled_payment[description]'
    end
  end
end
