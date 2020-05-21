require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @subject = create(:user)
  end

  it 'is valid with email-address, username and password' do
    expect(@subject).to be_valid
  end

  context 'Validations' do
    context 'Email' do
      it 'is only valid with an email-address' do
        expect(@subject).to be_valid

        @subject.email = nil

        expect(@subject).not_to be_valid
      end

      it 'is only valid, if the email-address is unique' do
        expect(@subject).to be_valid

        second_user = User.new(
            email: @subject.email,
            username: '_test_user',
            password: 'valid_password'
        )

        expect(second_user).not_to be_valid
      end
    end

    context 'Username' do
      it 'is only valid with a username' do
        expect(@subject).to be_valid

        @subject.username = nil

        expect(@subject).not_to be_valid
      end

      it 'is only valid, if the username is unique' do
        expect(@subject).to be_valid

        second_user = User.new(
            email: '_test_user@loan-manager.com',
            username: @subject.username,
            password: 'valid_password'
        )

        expect(second_user).not_to be_valid
      end
    end

    context 'Password' do
      it 'cannot be saved without a password' do
        expect(@subject).to be_valid

        @subject.password = nil

        expect(@subject).not_to be_valid
      end
    end
  end
end
