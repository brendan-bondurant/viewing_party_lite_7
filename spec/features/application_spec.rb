require 'rails_helper'

RSpec.describe 'application (/)' do
  before :each do
    @user1 = User.create!(name: 'Brendan', email: 'brendan@turing.edu', password: "12345", password_confirmation: "12345")
    @user2 = User.create!(name: 'Paul', email: 'paul@turing.edu', password: "12345", password_confirmation: "12345")
    @user3 = User.create!(name: 'Sooyung', email: 'sooyung@turing.edu', password: "12345", password_confirmation: "12345")
  end

  describe 'as a visitor' do
    describe 'when I visit /' do
      it 'shows the title of the application (Viewing Party)' do
        visit '/'

        expect(page).to have_content('Viewing Party')
      end

      it 'has a button to create a new user' do
        visit '/'

        expect(page).to have_button('Create a New User')

        click_button('Create a New User')

        expect(current_path).to eq(register_path)
      end

      #needs to be altered for authentication
      it 'has a list of existing users and links to their dashboard' do
        visit '/'
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        save_and_open_page
        expect(page).to have_content('Existing Users')
        expect(page).to have_link(@user1.email)
        expect(page).to have_link(@user2.email)
        expect(page).to have_link(@user3.email)

        click_link(@user3.email)

        expect(current_path).to eq(user_path(@user3))
      end

      it 'has a link that takes you back to the landing page' do
        visit '/'

        expect(page).to have_link('Home')

        click_link('Home')
        expect(current_path).to eq('/')
      end
    end

    describe 'staying logged in' do
      it 'has a link to log out' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        visit root_path
        expect(page).to have_link('Log Out')
        click_link 'Log Out'
        expect(current_path).to eq(root_path)
      end
      it 'does not have a link to log in' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        visit root_path
        expect(page).not_to have_link('Log In')
        expect(page).not_to have_link('Create a New User')
      end
    end

#     As a visitor
#     When I visit the landing page
#     I do not see the section of the page that lists existing users
    describe 'authorization' do 
      it 'does not have a section that lists existing users if visitor' do
        visit root_path
        expect(page).not_to have_content('Existing Users')
      end
#       As a registered user
#       When I visit the landing page
#       The list of existing users is no longer a link  to their show pages
#       But just a list of email addresses
    end
  end
end
