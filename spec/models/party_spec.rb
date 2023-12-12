require 'rails_helper'

RSpec.describe Party, type: :model do
  describe 'relationships' do
    it { should have_many(:party_users) }
    it { should have_many(:users) }
  end
  describe 'validations' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:party_date) }
    it { should validate_presence_of(:duration_of_party) }
  end

  describe 'instance methods' do
    before(:each) do
      @user_1 = User.create!(name: 'Kiwi', email: 'kiwibird@gmail.com', password: 'abcde')
      @user_2 = User.create!(name: 'Chicken', email: 'chickenbird@gmail.com', password: 'abcde')
      @user_3 = User.create!(name: 'Coco', email: 'cocobird@gmail.com', password: 'abcde')
      @party_1 = Party.create!(movie_id: 926_393, duration_of_party: 109, party_date: '2024-10-10', start_time: '07:23')
      PartyUser.create!(user_id: @user_1.id, party_id: @party_1.id, is_host: true)
      PartyUser.create!(user_id: @user_2.id, party_id: @party_1.id, is_host: false)
      PartyUser.create!(user_id: @user_3.id, party_id: @party_1.id, is_host: false)
    end

    describe '#get_host_name' do
      it "returns the name of the party's host" do
        expect(@party_1.get_host_name).to eq(@user_1.name)
      end
    end

    describe '#get_guest_names' do
      it 'returns an array of names of guests' do
        expect(@party_1.get_guest_names).to eq([@user_2.name, @user_3.name])
      end
    end
  end
end
