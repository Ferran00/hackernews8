class ApplicationController < ActionController::Base
  skip_forgery_protection
  helper_method :current_user
  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id]) 
  end
end
