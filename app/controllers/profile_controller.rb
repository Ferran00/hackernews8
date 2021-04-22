class ProfileController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def update
    current_user.update(about: params[:about], email: params[:email] )
  end
end