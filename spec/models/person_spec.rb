require 'rails_helper'

RSpec.describe Person, type: :model do
  before(:each) do
    @user = create(:user)
    @person = build(:person)
    @person.user_id = @user.id
  end

  it 'is valid with a user' do
    expect(@person).to be_valid
  end

  it 'is invalid without an originator (user)' do
    @person.user_id = nil

    expect(@person).not_to be_valid
  end

  it 'is valid without a first name' do
    @person.first_name = nil

    expect(@person).to be_valid
  end

  it 'is valid without a last name' do
    @person.last_name = nil

    expect(@person).to be_valid
  end

  it 'is valid without a phone number' do
    @person.phone_number = nil

    expect(@person).to be_valid
  end
end
