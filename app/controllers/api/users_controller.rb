class Api::UsersController < ApplicationController
  
  puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1"
  def getProfile
    respond_to do |format|  
      if request.headers['token'].present?
          puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 2"
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
            puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 3"
          @user  = User.find(api_key: @key)
          format.json { render json: { id: @user.id, username: @user.email, karma: @user.karma, about: @user.about, created_at: @user.created_at, api_key: @user.api_key}}
        else
          puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 4"
          format.json { render json: {error: "error", code: 404, message: "The user with token: " + @key + " doesn't exist"}, status: :not_found}
        end
      else
        puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 5"
        format.json { render json:{status:"error", code:403, message: "The autentication token is not provided"}, status: :forbidden}
      end
    end
  end
  
  def updateProfile
    respond_to do |format|
      if request.headers['token'].present?
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
          @user  = User.find(api_key: @key)
          @user.about = params[:about]
          @user.email = params[:email]
          @user.save
          format.json { render json: {id: @user.id, username: @user.email, karma: @user.karma, about: @user.about, created_at: @user.created_at, api_key: @user.api_key}, status: :ok}
        else
          format.json { render json: {error: "error", code: 404, message: "The user with token: " + @key + " doesn't exist"}, status: :not_found}
        end
      else
        format.json { render json:{status:"error", code:403, message: "The autentication token is not provided"}, status: :forbidden}
      end
    end
  end
end