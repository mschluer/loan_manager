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
end
