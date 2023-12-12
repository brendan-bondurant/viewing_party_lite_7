# frozen_string_literal: true

require 'rails_helper'

# As a visitor
# When I visit `/register`
# I see a form to fill in my name, email, password, and password confirmation.
# When I fill in that form with my name, email, and matching passwords,
# I'm taken to my dashboard page `/users/:id`

RSpec.describe 'User registration form' do
  it 'creates new user' do
    visit '/register'

    name = 'test name'
    email = 'test@testing.com'
    password = 'test'

    fill_in :user_name, with: name
    fill_in :user_email, with: email
    fill_in :user_password, with: password
    fill_in :user_password_confirmation, with: password

    click_on 'Create New User'
    expect(current_path).to eq(user_path(User.last.id))
  end

  #   As a visitor
  # When I visit `/register`
  # and I fail to fill in my name, unique email, OR matching passwords,
  # I'm taken back to the `/register` page
  # and a flash message pops up, telling me what went wrong
  it 'tells you if a field is empty' do
    visit '/register'

    name = 'test name'
    email = 'test@testing.com'
    password = 'test'

    fill_in :user_name, with: name
    # fill_in :email, with: email
    fill_in :user_password, with: password
    fill_in :user_password_confirmation, with: password

    click_on 'Create New User'
    expect(current_path).to eq('/register')
    expect(page).to have_content('Please fill out name, email, and password to create an account')
  end
end
