# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'scheduled_payments/show', type: :view do
  before(:each) do
    @scheduled_payment = assign(:scheduled_payment, create(:scheduled_payment,
                                                           payment_amount: 1.5,
                                                           description: 'Scheduled Payment Text',
                                                           loan_id: 2))
  end

  it 'renders attributes in <p>' do
    render

    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/Scheduled Payment Text/)
    expect(rendered).to match(/2/)
  end
end
