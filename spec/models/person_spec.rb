# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person, type: :model do
  before(:each) do
    @person = create(:person)
    @person.user_id = 1
  end

  it 'is valid with a user' do
    expect(@person).to be_valid
  end

  it 'is invalid without an originator (user)' do
    @person.user_id = nil

    expect(@person).not_to be_valid
  end

  it 'is invalid without a first name' do
    @person.first_name = nil

    expect(@person).not_to be_valid
  end

  it 'is invalid without a last name' do
    @person.last_name = nil

    expect(@person).not_to be_valid
  end

  it 'is valid without a phone number' do
    @person.phone_number = nil

    expect(@person).to be_valid
  end

  describe 'full_name' do
    it 'returns the full name' do
      person = build(:person, first_name: 'First', last_name: 'Last')

      expect(person.full_name).to eq 'First Last'
    end
  end

  describe 'id_with_full_name' do
    it 'returns the correct id with full name' do
      person = create(:person, first_name: 'first name', last_name: 'last name')

      expect(person.id_with_full_name).to eq "##{person.id} first name last name"
    end

    it 'does not crash without an id given yet' do
      person = build(:person, first_name: 'first name', last_name: 'last name')

      expect(person.id_with_full_name).to eq '# first name last name'
    end
  end

  describe 'total_balance' do
    it 'returns 0 if there are no loans' do
      expect(@person.total_balance).to be_zero
    end

    it 'returns a positive amount if balance is positive' do
      create(:loan, person: @person, total_amount: 20)
      create(:loan, person: @person, total_amount: 10)

      expect(@person.total_balance).to eq(30)
    end

    it 'returns a negative amount if balance is negative' do
      create(:loan, person: @person, total_amount: -20)
      create(:loan, person: @person, total_amount: -10)

      expect(@person.total_balance).to eq(-30)
    end
  end

  describe 'average_loan_duration_date' do
    it 'returns -1 if there are no loans' do
      expect(create(:person).average_loan_duration_days).to eq -1
    end

    it 'returns the duration date if there is one loan' do
      person = create(:person)

      create(:loan, person: person, date: 3.days.ago)

      expect(person.average_loan_duration_days).to eq 3
    end

    it 'returns the average duration date if there are more than one loans' do
      person = create(:person)

      create(:loan, person: person, date: 3.days.ago)
      create(:loan, person: person, date: 1.days.ago)

      expect(person.average_loan_duration_days).to eq 2
    end

    it 'returns the average duration date if there are paid loans' do
      person = create(:person)

      loan_1 = create(:loan, person: person, date: 4.days.ago, total_amount: -1)
      loan_2 = create(:loan, person: person, date: 4.days.ago, total_amount: -2)

      create(:payment, loan: loan_1, payment_amount: 1, date: 2.days.ago)
      create(:payment, loan: loan_2, payment_amount: 2, date: 4.days.ago)

      expect(person.average_loan_duration_days).to eq 1
    end
  end
end
