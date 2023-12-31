class ViewingPartyController < ApplicationController
  def new
    if params[:user_id] != nil
      @facade = MovieDetailsFacade.new(params[:movie_id])
      @user = User.find(params[:user_id])
      @users = User.all
    else
      flash[:error] = "You must be logged in or registered to create a viewing party"
      redirect_to movies_path
    end
  end

  def create
    host = User.find(params[:id])
    party = Party.new(party_params)

    if party.save
      host_of_party(host, party)
      attendees_of_party(party)
      redirect_to user_path(host)
    else
      redirect_to new_user_movie_viewing_party_path(host, params[:movie_id])
      flash[:error] = 'Please fill out all field, duration, time and date of the party'
    end
  end

  private

  def party_params
    params.permit(:movie_id, :duration_of_party, :party_date, :start_time)
  end

  def host_of_party(host, party)
    PartyUser.create!(user_id: host.id, party_id: party.id, is_host: true)
  end

  def attendees_of_party(party)
    params[:invites].map do |invite|
      PartyUser.create!(user_id: invite, party_id: party.id)
    end
  end
end