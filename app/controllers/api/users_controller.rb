class Api::UsersController < ApplicationController
  
  def getProfile
    respond_to do |format|  
      if request.headers['token'].present?
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
          @user  = User.find_by(api_key: @key)
          format.json { render json: { id: @user.id, username: @user.email, karma: @user.karma, about: @user.about, created_at: @user.created_at, api_key: @user.api_key}}
        else
          format.json { render json: {error: "error", code: 404, message: "The user with token: " + @key + " doesn't exist"}, status: :not_found}
        end
      else
        format.json { render json:{status:"error", code:403, message: "The autentication token is not provided"}, status: :forbidden}
      end
    end
  end
  
  def updateProfile
    respond_to do |format|
      if request.headers['token'].present?
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
          @user  = User.find_by(api_key: @key)
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