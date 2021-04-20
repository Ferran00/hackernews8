    def googleAuth
        # if @current_user.nil?
            # Get access tokens from the google server
            access_token = request.env["omniauth.auth"]
            user = User.from_omniauth(access_token)
            
            session[:user_id] = access_token["uid"]
            @current_user = @user_id
            
            # log_in(user)
            # Access_token is used to authenticate request made from the rails application to the google server
            user.google_token = access_token.credentials.token
            # Refresh_token to request new access_token
            # Note: Refresh_token is only sent once during the first request
            refresh_token = access_token.credentials.refresh_token
            user.google_refresh_token = refresh_token if refresh_token.present?
            user.save
        # end
        redirect_to '/'
end