# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'discover movies' do
  before(:each) do
    @user1 = User.create!(name: 'Brendan', email: 'brendan@turing.edu', password: "12345", password_confirmation: "12345")
    @user2 = User.create!(name: 'Paul', email: 'paul@turing.edu', password: "12345", password_confirmation: "12345")
    @user3 = User.create!(name: 'Sooyung', email: 'sooyung@turing.edu', password: "12345", password_confirmation: "12345")
  end

  it 'has a home link, discover movies title, search field, find top rated movies and find movies buttons' do
    visit discover_user_path(@user1)
    expect(page).to have_link('Home')
    expect(page).to have_content('Discover Movies')
    expect(page).to have_field('search')
    expect(page).to have_button('Find Top Rated Movies')
    expect(page).to have_button('Find Movies')
  end

  it 'shows the top rated movies and their average rating' do
    json_response = File.read('spec/fixtures/top_rated.json')
    parsed = JSON.parse(json_response, symbolize_names: true)
    movies = parsed[:results]
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{Rails.application.credentials.tmdb[:key]}")
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Faraday v2.7.12'
        }
      )
      .to_return(status: 200, body: json_response, headers: {})
    visit discover_user_path(@user1)
    expect(page).to have_button('Find Top Rated Movies')
    click_button('Find Top Rated Movies')
    expect(current_path).to eq(user_movies_path(@user1))
    movies.each do |movie|
      expect(movie[:title]).to be_a(String)
      expect(page).to have_content(movie[:vote_average])
    end
  end
  
  it 'has a button to return to discover' do
    visit user_movies_path(@user2)
    expect(page).to have_button('Discover Page')
    click_button 'Discover Page'
    expect(current_path).to eq(discover_user_path(@user2))
  end

  it 'returns objects that are searched for' do
    json_response = File.read('spec/fixtures/star_wars.json')
    stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{Rails.application.credentials.tmdb[:key]}&query=Star%20Wars")
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Faraday v2.7.12'
      }
      )
      .to_return(status: 200, body: json_response, headers: {})
    visit discover_user_path(@user1.id)
    expect(find_field('search').value).to eq(nil)
    fill_in('search', with: 'Star Wars')
    click_button 'Find Movies'
    expect(current_path).to eq(user_movies_path(@user1.id))
    expect(page).to have_content('Star Wars')
    expect(page).to have_content('Star Wars Holiday Special')
    expect(page).to have_css('section.movie', count: 20)
  end
end
