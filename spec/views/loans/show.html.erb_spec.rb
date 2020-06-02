# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'loans/show', type: :view do
  before(:each) do
    @loan = assign(:loan, create(:loan,
                                 name: 'loan_name',
                                 total_amount: 2.5,
                                 description: 'loan_description',
                                 date: '2020-04-09'))
  end

  it 'renders the page correctly' do
    create(:payment, loan: @loan, description: 'payment_', payment_amount: 11.1)
    create(:scheduled_payment, loan: @loan, description: 'scheduled_payment_', payment_amount: 22.2)

    render
    expect(rendered).to match(/loan_name/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/loan_description/)
    expect(rendered).to match(/2020-04-09/)
    expect(rendered).to match(/#{ERB::Util.html_escape @loan.person.full_name}/)
    expect(rendered).to match(/#{ERB::Util.html_escape @loan.person.user.username}/)

    expect(rendered).to match(/Account Statement/)
    expect(rendered).to match(/payment_/)
    expect(rendered).to match(/11.1/)

    expect(rendered).to match(/Scheduled Payments/)
    expect(rendered).to match(/scheduled_payment_/)
    expect(rendered).to match(/22.2/)
  end

  it 'does not render account statement and scheduled payments section if nothing to show' do
    render

    expect(rendered).not_to match(/Account Statement/)
    expect(rendered).not_to match(/Scheduled Payments/)
  end
end
