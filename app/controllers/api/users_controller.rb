class Api::UsersController < ApplicationController
  def getProfile
    respond_to do |format|  
      if request.headers['token'].present?
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
          @user  = User.find_by(api_key: @key)
          format.json { render json: {username: @user.username, created_at: @user.created_at, karma: @user.karma, about: @user.about, email: @user.email, api_key: @user.api_key, id: @user.id}}
        else
          format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else
        format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
      end
    end
  end
  
  def getOtherProfile
    respond_to do |format|  
      if !params[:email].nil?
        if request.headers['token'].present?
          @key = request.headers['token'].to_s
          if User.exists?(api_key: @key)
            @user  = User.find_by(email: params[:email])
            format.json { render json: {username: @user.username, created_at: @user.created_at, karma: @user.karma, about: @user.about, email: @user.email}}
          else
            format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
          end
        else
          format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
        end
      else 
        format.json { render json:{status:"error", code:400, message: "No email specified (query)"}, status: :bad_request}
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
          format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else
        format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
      end
    end
  end
  
  def getUserNews 
    respond_to do |format|
      if !params[:email].nil?
        if request.headers['token'].present?
          @key = request.headers['token'].to_s
          if User.exists?(api_key: @key)
            if User.exists?(email: params[:email])
              @myuser = User.find_by(:email => params[:email])
              @otherUserNews = New.where(:user_id => @myuser.id).order('points DESC').all
              format.json { render json: @otherUserNews, status: :ok}
            else
              format.json { render json: {error: "error", code: 404, message: "The user with email: " + params[:email] + " doesn't exist"}, status: :not_found}
            end   
          else
            format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
          end
        else
          format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
        end
      else 
        format.json { render json:{status:"error", code:400, message: "No email specified (query)"}, status: :bad_request}
      end
    end
  end
  
end