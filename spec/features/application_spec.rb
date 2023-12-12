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

      it 'has a list of existing users and links to their dashboard' do
        visit '/'

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
  end
end
