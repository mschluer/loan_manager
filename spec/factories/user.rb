include BCrypt

FactoryBot.define do
  factory :user, class: 'User' do
    email { 'basic_user@loan-manager.com' }
    username { 'Basic_User' }
    password { Password.create('.test.') }
  end
end