class SessionsController < ApplicationController
    def googleAuth
        # Get access tokens from the google server
        user_info = request.env["omniauth.auth"]
        temp_id = (user_info.uid.to_i % 1048576)
        user_info.uid = temp_id
        user = User.from_omniauth(user_info)

        # Access_token is used to authenticate request made from the rails application to the google server
        user.google_token = user_info.credentials.token
        # Refresh_token to request new user_info
        # Note: Refresh_token is only sent once during the first request
        refresh_token = user_info.credentials.refresh_token
        user.google_refresh_token = refresh_token if refresh_token.present?
        user.id = temp_id
        user.save

        session[:user_id] = temp_id
        @current_user = session[:user_id]

        redirect_to root_path
    end
    
    def logout
        session[:user_id] = nil
        @current_user = nil
        
        redirect_to root_path
    end
end