# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledPayment, type: :model do
  before(:each) do
    @scheduled_payment = build(:scheduled_payment)
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

  context 'overdue?' do
    it 'is overdue, if it\'s date is yesterday' do
      @scheduled_payment.date = 1.day.ago
      expect(@scheduled_payment).to be_overdue
    end

    it 'is not overdue if it\'s date is today' do
      @scheduled_payment.date = DateTime.now
      expect(@scheduled_payment).not_to be_overdue
    end

    it 'is not overdue if it\'s date is tomorrow' do
      @scheduled_payment.date = 5.days.from_now
      expect(@scheduled_payment).not_to be_overdue
    end

    it 'shows the correct string for overdue' do
      @scheduled_payment.date = 1.day.ago
      expect(@scheduled_payment.due_string).to eq 'Since 1 Day'

      @scheduled_payment.date = 2.days.ago
      expect(@scheduled_payment.due_string).to eq 'Since 2 Days'
    end

    it 'shows the correct string for !overdue' do
      @scheduled_payment.date = 1.day.from_now
      expect(@scheduled_payment.due_string).to eq 'In 1 Day'

      @scheduled_payment.date = 2.days.from_now
      expect(@scheduled_payment.due_string).to eq 'In 2 Days'
    end
  end
end
