# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Loan, type: :model do
  before(:each) do
    @loan = build(:loan)
    @loan.person_id = 1
  end

  it 'is valid with a complete set of data and positive total amount' do
    expect(@loan).to be_valid
  end

  it 'is only valid with a name' do
    @loan.name = nil

    expect(@loan).not_to be_valid
  end

  it 'is valid with a negative total amount' do
    @loan.total_amount = -1.5

    expect(@loan).to be_valid
  end

  it 'is valid without a description' do
    @loan.description = nil

    expect(@loan).to be_valid
  end

  it 'is not valid without a date' do
    @loan.date = nil

    expect(@loan).not_to be_valid
  end

  it 'is only valid with a person' do
    @loan.person = nil

    expect(@loan).not_to be_valid
  end
end
