# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'scheduled_payments/index', type: :view do
  before(:each) do
    assign(:scheduled_payments,
           [
             ScheduledPayment.create!(
               payment_amount: 2.5,
               date: '2021-01-01',
               description: 'Scheduled Payment Description Text',
               loan_id: 2
             ),
             ScheduledPayment.create!(
               payment_amount: 2.5,
               date: '2021-01-01',
               description: 'Scheduled Payment Description Text',
               loan_id: 2
             )
           ])
  end

  it 'renders a list of scheduled_payments' do
    render
    assert_select 'tr>td', text: 'Scheduled Payment Description Text'.to_s, count: 2
    assert_select 'tr>td', text: 2.5.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
  end
end
