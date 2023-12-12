require 'rails_helper'

RSpec.describe 'Movie Details Page', type: :feature do
  before(:each) do
    @user = User.create!(name: 'Morgan', email: 'morgan@email.com', password: "12345", password_confirmation: "12345")
  end

  describe "When I visit a movie's details page '/users/:user_id/movies/:id'" do
    it 'has a create viewing party button' do
      VCR.use_cassette('dune_details') do
        visit "/users/#{@user.id}/movies/438631"
        expect(page).to have_button('Create Viewing Party for Dune')
        click_button('Create Viewing Party for Dune')
        expect(current_path).to eq("/users/#{@user.id}/movies/438631/viewing_party/new")
      end
    end
    
    it 'I can see a button to return to the discover page' do
      VCR.use_cassette('dune_details') do
        visit "/users/#{@user.id}/movies/438631"

        expect(page).to have_button('Discover Movies')
        click_button 'Discover Movies'
        expect(current_path).to eq("/users/#{@user.id}/discover")
      end
    end
    
    it 'shows movie title, vote average, runtime in hours and minutes, genre(s), and a summary description' do
      VCR.use_cassette('dune_details') do
        visit "/users/#{@user.id}/movies/438631"
        
        expect(page).to have_content('Dune')
        expect(page).to have_content('Vote:')
        expect(page).to have_content('Runtime: 2h 35m')
        expect(page).to have_content('Genre(s): Science Fiction Adventure')
        
        within('#summary') do
          expect(page).to have_content('Summary:')
          expect(page).to have_content("Paul Atreides, a brilliant and gifted young man born into a great destiny beyond his understanding, must travel to the most dangerous planet in the universe to ensure the future of his family and his people. As malevolent forces explode into conflict over the planet's exclusive supply of the most precious resource in existence-a commodity capable of unlocking humanity's greatest potential-only those who can conquer their fear will survive.")
        end
      end
    end

    it 'shows a list of the first 10 cast members' do
      VCR.use_cassette('dune_details') do
        visit "/users/#{@user.id}/movies/438631"

        within('#cast') do
          expect(page).to have_content('Cast:')
          expect(page).to have_content('Timothée Chalamet - Paul Atreides')
          expect(page).to have_content('Rebecca Ferguson - Lady Jessica Atreides')
          expect(page).to have_content('Oscar Isaac - Duke Leto Atreides')
        end
      end
    end

    it 'should have a count of total reviews, with each author and their information' do
      VCR.use_cassette('dune_details') do
        visit "/users/#{@user.id}/movies/438631"

        within('#reviews') do
          expect(page).to have_content('13 Reviews:')
          expect(page).to have_content('Review by: Habenula')
          expect(page).to have_content("The worst movie I've ever seen. Don't waste your time.")
          expect(page).to have_content('Review by: tahmid_007')
          expect(page).to have_content('Great movie with excellent BG music and visual effects. Waiting for part two.')
        end
      end
    end
  end
end