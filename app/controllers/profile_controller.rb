class ProfileController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def update
    @user = User.find(current_user.id)
    @user.about = params[:about]
    @user.email = params[:email] 
    @current_user = @user
    @user.save
  end
end