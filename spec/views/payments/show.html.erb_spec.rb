# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'payments/show', type: :view do
  before(:each) do
    @payment = assign(:payment, create(:payment,
                                       payment_amount: 2.5,
                                       description: 'payment_description'))
  end

  it 'renders attributes in <p>' do
    render

    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/payment_description/)
  end
end
