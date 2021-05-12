class Api::UsersController < ApplicationController
  def getProfile
    respond_to do |format|  
      if request.headers['token'].present?
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
          @user  = User.find_by(api_key: @key)
          format.json { render json: {username: @user.username, created_at: @user.created_at, karma: @user.karma, about: @user.about, email: @user.email, api_key: @user.api_key, id: @user.id}}
        else
          format.json { render json: {error: "error", code: 404, message: "The user with token: " + @key + " doesn't exist"}, status: :not_found}
        end
      else
        format.json { render json:{status:"error", code:403, message: "The autentication token is not provided"}, status: :forbidden}
      end
    end
  end
  
  def getOtherProfile
    respond_to do |format|  
      if request.headers['token'].present?
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
          @user  = User.find_by(email: params[:email])
          format.json { render json: {username: @user.username, created_at: @user.created_at, karma: @user.karma, about: @user.about}}
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
          @about = params[:about]
          @email = params[:email]
          if(!@about.nil?)
            @user.about = @about
          end
          if(!@email.nil?)
            @user.email = @email
          end
          @user.save
          
          format.json { render json: {username: @user.username, created_at: @user.created_at, karma: @user.karma, about: @user.about, email: @user.email, api_key: @user.api_key, id: @user.id}, status: :ok}
        else
          format.json { render json: {error: "error", code: 404, message: "The user with token: " + @key + " doesn't exist"}, status: :not_found}
        end
      else
        format.json { render json:{status:"error", code:403, message: "The autentication token is not provided"}, status: :forbidden}
      end
    end
  end
  
  def getUserNews 
    respond_to do |format|
      if request.headers['token'].present?
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
          @email  = params[:email]
          @user = User.find_by(email: @email)
          @otherUserNews = New.where(user_id: @user.id).order('points DESC').all
          format.json { render json: @otherUserNews, status: :ok}
        else
          format.json { render json: {error: "error", code: 404, message: "The user with token: " + @key + " doesn't exist"}, status: :not_found}
        end
      else
        format.json { render json:{status:"error", code:403, message: "The autentication token is not provided"}, status: :forbidden}
      end
    end
  end
          
          
end