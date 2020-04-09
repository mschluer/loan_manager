require 'rails_helper'

RSpec.describe Payment, type: :model do
  before(:each) do
    @user = create(:user)

    @person = build(:person)
    @person.user = @user
    @person.save

    @loan = build(:loan)
    @loan.person = @person
    @loan.save

    @payment = build(:payment)
    @payment.loan = @loan
  end

  it 'is valid with a complete dataset with positive payment_amount' do
    expect(@payment).to be_valid
  end

  it 'is valid with a complete dataset with negative payment_amount' do
    @payment.payment_amount = -5.0

    expect(@payment).to be_valid
  end

  it 'is not valid without payment_amount' do
    @payment.payment_amount = nil

    expect(@payment).not_to be_valid
  end

  it 'is not valid without a date' do
    @payment.date = nil

    expect(@payment).not_to be_valid
  end

  it 'is valid without a description' do
    @payment.description = nil

    expect(@payment).to be_valid
  end

  it 'is invalid without a loan' do
    @payment.loan = nil

    expect(@payment).not_to be_valid
  end
end
