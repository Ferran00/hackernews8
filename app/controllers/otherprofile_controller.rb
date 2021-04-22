class OtherprofileController < ApplicationController
  def index
    @actual_user = User.find(params[:userid])
    @name = @actual_user.username
    @created = @actual_user.created_at.strftime("%B %d, %Y")
    @karma = @actual_user.karma
    @about = @actual_user.about
    @id = params[:userid]
  end
  
  render "otherprofile/index"
end