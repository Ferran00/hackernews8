class SessionsController < ApplicationController
    def googleAuth
        # if @current_user.nil?
            # Get access tokens from the google server
            user_info = request.env["omniauth.auth"]
            user = User.from_omniauth(user_info)
            
            session[:user_id] = user_info["uid"]
            @current_@user = User.find(user_info["uid"])
            # @current_user = @user_id
            
            # log_in(user)
            # Access_token is used to authenticate request made from the rails application to the google server
            user.google_token = user_info.credentials.token
            # Refresh_token to request new user_info
            # Note: Refresh_token is only sent once during the first request
            refresh_token = user_info.credentials.refresh_token
            user.google_refresh_token = refresh_token if refresh_token.present?
            user.save
        # end
        redirect_to root_path
    end
end