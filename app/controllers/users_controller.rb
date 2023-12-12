class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def discover
    @user = User.find(params[:id])
  end

  def show
    @facade = UserFacade.new(params[:id])
  end

  def login_form; end

  def login_user
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path(user.id)
    else
      flash[:error] = "Invalid Credentials"
      redirect_to '/login'
    end
  end

  def create
    user = user_params
    user[:email] = user[:email].downcase
    new_user = User.new(user)
    session[:user_id] = user.id
    if new_user.save
      flash[:success] = "Welcome, #{new_user.name}!"
      redirect_to user_path(new_user.id)
    else
      redirect_to register_path
      flash[:error] = 'Please fill out name, email, and password to create an account'
    end
  end

  private

  def user_params
    if params[:user] != nil
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    else
    params.permit(:name, :email)
    end
  end
end