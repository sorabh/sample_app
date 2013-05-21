class SessionsController < ApplicationController
  def create
    if user = User.authenticate(params[:name],params[:password])
      session[:user_id]=user.id
      redirect_to home_url
    else
      redirect_to login_url ,:alert => 'Invalid user name/password combination'
    end
  end

  def new

  end

  def destroy
    session[:user_id] = nil
    redirect_to home_url, :notice => "Logged out"
  end

end
