class ProfileController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def update
    @user = User.find(current_user.id)
    @user.about = params[:about]
    @user.email = params[:email] 
    @user.save
    @current_user = @user
  end
end