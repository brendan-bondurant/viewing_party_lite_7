require 'rails_helper'

RSpec.describe UserFacade do
  describe 'facade returns details', :vcr do
    before(:each) do
      @user = User.create!(name: 'Kiwi', email: 'kiwibird@gmail.com', password: "12345", password_confirmation: "12345")
      @facade = UserFacade.new(@user.id)
    end

    it 'exists' do
      expect(@facade).to be_an_instance_of(UserFacade)
      expect(@facade.user).to be_an_instance_of(User)
    end

    it 'returns a link to grab a movie poster from TMDB' do
      expect(@facade.movie_poster_link(346698)).to be_a String
    end

    it 'returns a movie title from TMDB' do
      expect(@facade.get_movie_title(346698)).to be_a String
    end

    it 'hosts a party' do
      expect(@facade.user.hosted_parties).to eq([])
    end

    it 'returns an array of parties' do
      expect(@facade.user.parties).to eq([])
      expect(@facade.user.invited_parties).to eq([])
    end

    it 'excludes the id' do
      expect(User.all_excluding_id(@facade.user.id)).to eq([])
    end

    it 'finds the host and guest name' do
      user1 = User.create!(name: 'Sam', email: 'sam@email.com', password: "12345", password_confirmation: "12345")
      user2 = User.create!(name: 'Susan', email: 'susan@email.com', password: "12345", password_confirmation: "12345")
      party_params = { movie_id: 129, duration_of_party: 155, party_date: '2020/12/12', start_time: '12:12' }
      party = Party.create!(party_params)
      PartyUser.create!(user_id: user1.id, party_id: party.id, is_host: true)
      user2.parties << party
      expect(party.get_host_name).to eq(user1.name)
      expect(party.get_guest_names).to eq([user2.name])
    end
  end
end
