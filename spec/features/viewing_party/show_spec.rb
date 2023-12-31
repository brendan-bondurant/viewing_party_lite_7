require 'rails_helper'

RSpec.describe 'Viewing Party Page', type: :feature do
  describe "viewing party details", :vcr do
    before(:each) do
      @user = User.create!(name: 'Morgan', email: 'morgan@email.com', password: "12345", password_confirmation: "12345")
      @user1 = User.create!(name: 'Sam', email: 'sam@email.com', password: "12345", password_confirmation: "12345")
      @user2 = User.create!(name: 'Susan', email: 'susan@email.com', password: "12345", password_confirmation: "12345")
      visit new_user_movie_viewing_party_path(@user, 129)
    end

    describe 'when I visit /users/:user_id/movies/:movies_id/viewing_party/new' do
      it 'shows the title of the movie' do
        expect(page).to have_content('Create a Movie Party for Spirited Away')
      end

      it 'shows viewing party details, including movie title, duration of party, day and start time' do
        expect(page).to have_content('Viewing Party Details')
        expect(page).to have_content('Movie Title')
        expect(page).to have_content('Spirited Away')
        expect(page).to have_content('Duration of Party')
        expect(page).to have_content('Start Date')
        expect(page).to have_content('Start Time')
        expect(page).to have_field('duration_of_party', with: 125)
      end

      it 'gives you an error if info is missing' do
        click_button('Create Party')
        expect(page).to have_content('Please fill out all field, duration, time and date of the party')
      end

      it 'creates a new viewing party' do
        fill_in('party_date', with: '2023-12-01')
        fill_in('start_time', with: '07:00')

        within("#user-#{@user1.id}") do
          check("invites[]")
        end

        within("#user-#{@user2.id}") do
          check("invites[]")
        end

        click_button('Create Party')

        expect(current_path).to eq(user_path(@user))
        expect(page).to have_content('Movie Title: Spirited Away')
        expect(page).to have_content('Duration: 125 minutes')
        expect(page).to have_content('Date: Dec 01, 2023')
        expect(page).to have_content('Start Time: 07:00 AM')
        expect(page).to have_content('Host: Morgan')
        expect(page).to have_content('Guest List: Sam, Susan')
      end
      #commented out because of changes made during session authorization assignment
      # it 'excludes host id' do
      #   people = User.all
      #   expect(people).to eq([@user, @user1, @user2])
      #   expect(people.all_excluding_id(@user.id)).to eq([@user1, @user2])
      # end
    end
  end
end
