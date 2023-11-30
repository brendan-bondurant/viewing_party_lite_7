require 'rails_helper'

RSpec.describe 'discover movies' do
  before (:each) do
    @user1 = User.create!(name: 'Brendan', email: 'brendan@turing.edu')
    @user2 = User.create!(name: 'Paul', email: 'paul@turing.edu')
    @user3 = User.create!(name: 'Sooyung', email: 'sooyung@turing.edu')
  end
  it 'click find top rated movies' do
    json_response = File.read('spec/fixtures/top_rated.json')
    parsed = JSON.parse(json_response, symbolize_names: true)
    movies = parsed[:results]
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{Rails.application.credentials.tmdb[:key]}").
        with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Faraday v2.7.12'
          }).
      to_return(status: 200, body: json_response, headers: {})
    visit discover_user_path(@user1.id)
    click_button "Find Top Rated Movies"
    expect(current_path).to eq(user_movies_path(@user1.id))
  end
  it 'should have a search button' do
    json_response = File.read('spec/fixtures/empty_search.json')
    parsed = JSON.parse(json_response, symbolize_names: true)
    movies = parsed[:results]
    stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{Rails.application.credentials.tmdb[:key]}&query=")
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
    click_button 'Find Movies'
    expect(current_path).to eq(user_movies_path(@user1.id))
  end
  it 'allows for a search' do
    json_response = File.read('spec/fixtures/star_wars.json')
    # parsed = JSON.parse(json_response, symbolize_names: true)
    # movies = parsed[:results]
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
  end
end
