class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_current_user

  def set_current_user
    if session[:session_id]
      @user = User.find_by_session_id(session[:session_id])
    else
      @user = nil
      #redirect_to "login_url"
    end
  end
end
