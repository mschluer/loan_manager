# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @subject = create(:user)
  end

  it 'is valid with email-address, username and password' do
    expect(@subject).to be_valid
  end

  describe 'dependend' do
    it 'deletes all depending people when deleted itself' do
      person = create(:person, user: @subject)

      @subject.destroy
      expect { Person.find(person.id) }.to raise_exception(ActiveRecord::RecordNotFound)
    end

    it 'deletes all api_sessions when deleted itself' do
      api_session = create(:api_session, user: @subject)

      @subject.destroy
      expect { Api::Session.find(api_session.id) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
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

  it 'is possible to grant and revoke admin privileges' do
    user = create(:user)

    expect(user.admin?).to be false

    user.switch_admin_access!
    expect(user.admin?).to be true

    user.switch_admin_access!
    expect(user.admin?).to be false
  end
end
