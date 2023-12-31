# frozen_string_literal: true

class MoviesController < ApplicationController
  def index
    @user = User.find(params[:user_id])

    if params[:top_movies] == 'top rated'
      @facade = Top20Facade.new(params[:top_movies])
    elsif !params[:search].nil?
      @facade = MovieSearchFacade.new(params[:search])
    end
  end

  def show
    @facade = MovieDetailsFacade.new(params[:id])
    if @current_user != nil
      @user = User.find(params[:user_id])
    end
    
  end
end
