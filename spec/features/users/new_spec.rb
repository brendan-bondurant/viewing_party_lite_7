# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Registration', type: :feature do
  describe 'When I visit /register' do
    it 'has a form to create a new user' do
      visit root_path
      click_button 'Create a New User'

      expect(current_path).to eq(register_path)
      expect(page).to have_content('Register a New User')
      expect(page).to have_field('Name')
      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
      expect(page).to have_field('Password Confirmation')
      expect(page).to have_button('Create New User')
    end

    it 'creates a new user and redirects to the dashboard' do
      visit register_path
      fill_in('Name', with: 'River')
      fill_in('Email', with: 'riversong@tardis.net')
      fill_in('user_password', with: '12345')
      fill_in('user_password_confirmation', with: '12345')

      click_button 'Create New User'
      expect(current_path).to eq(user_path(User.last.id))
      expect(page).to have_content('Welcome, River!')
      expect(page).to have_content("River's Dashboard")
    end

    it 'shows an error if the name is blank' do
      visit register_path
      fill_in('Email', with: 'username@email.net')

      click_button 'Create New User'

      expect(current_path).to eq(register_path)
      expect(page).to have_content('Please fill out name, email, and password to create an account')
    end

    it 'shows an error if the email is blank' do
      visit register_path
      fill_in('Name', with: 'River')

      click_button 'Create New User'

      expect(current_path).to eq(register_path)
      expect(page).to have_content('Please fill out name, email, and password to create an account')
    end
  end
end
