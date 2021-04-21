class SessionsController < ApplicationController
    def googleAuth
        # if @current_user.nil?
            # Get access tokens from the google server
            user_info = request.env["omniauth.auth"]
            temp_id = (user_info.uid.to_i % 1048576)
            user_info.uid = temp_id
            user = User.from_omniauth(user_info)

            # @current_user = session[:user_id]
            
            # log_in(user)
            # Access_token is used to authenticate request made from the rails application to the google server
            user.google_token = user_info.credentials.token
            # Refresh_token to request new user_info
            # Note: Refresh_token is only sent once during the first request
            refresh_token = user_info.credentials.refresh_token
            user.google_refresh_token = refresh_token if refresh_token.present?
            puts user_info.uid
            user.id = temp_id
            puts temp_id
            user.save

            session[:user_id] = temp_id

            @current_user = session[:user_id]


            
        # end
        redirect_to root_path
    end
end