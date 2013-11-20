class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user and user.hashed_password == Base64.encode64(params[:password])
      session[:user_id] = user.id
      session[:user_email]= user.email
      #session[:session_string]= user.session_id
      session[:user_name]=user.name
      user.session_id = session[:session_id]
      user.save
      redirect_to root_path
    else
      redirect_to login_url
    end
  end

  def destroy
    session[:session_id] = nil
    reset_session
    redirect_to root_path
  end
end
