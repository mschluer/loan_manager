# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledPayment, type: :model do
  before(:each) do
    @scheduled_payment = build(:payment)
    @scheduled_payment.loan_id = 1
  end

  it 'is valid with a complete dataset with positive payment_amount' do
    expect(@scheduled_payment).to be_valid
  end

  it 'is valid with a complete dataset with negative payment_amount' do
    @scheduled_payment.payment_amount = -5.0

    expect(@scheduled_payment).to be_valid
  end

  it 'is not valid without payment_amount' do
    @scheduled_payment.payment_amount = nil

    expect(@scheduled_payment).not_to be_valid
  end

  it 'is not valid without a date' do
    @scheduled_payment.date = nil

    expect(@scheduled_payment).not_to be_valid
  end

  it 'is valid without a description' do
    @scheduled_payment.description = nil

    expect(@scheduled_payment).to be_valid
  end

  it 'is invalid without a loan' do
    @scheduled_payment.loan = nil

    expect(@scheduled_payment).not_to be_valid
  end
end
