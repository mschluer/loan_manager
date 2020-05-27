# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  before(:each) do
    assign(:users,
           [
             User.create!(
               email: 'test@example.com',
               username: 'Username',
               password: 'Password'
             ),
             User.create!(
               email: 'test1@example.com',
               username: 'Username1',
               password: 'Password'
             )
           ])
  end

  it 'renders a list of users' do
    render
    assert_select 'tr>td', text: 'test@example.com'.to_s
    assert_select 'tr>td', text: 'test1@example.com'.to_s
    assert_select 'tr>td', text: 'Username'.to_s
    assert_select 'tr>td', text: 'Username1'.to_s
  end
end
