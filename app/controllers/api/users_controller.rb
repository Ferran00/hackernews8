class Api::UsersController < ApplicationController
  
  CommentComplete = Struct.new(:comment, :replies, :author_username) do
  end
  
  NewComplete = Struct.new(:new, :comments, :author_username) do
  end
  
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
      if request.headers['token'].present?
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
          if User.exists?(id: params[:id])
            @user  = User.find_by(id: params[:id])
            format.json { render json: {username: @user.username, created_at: @user.created_at, karma: @user.karma, about: @user.about}, status: :ok}
          else
            format.json { render json:{status:"error", code:404, message: "User with ID '" + params[:id] + "' not found"}, status: :not_found}
          end  
        else
          format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else
        format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
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

  def funcio(singleComment)
    repliesCompleted = Set[]
    @commentsAlreadyUsed.add(singleComment)
    @comReplies = Comment.where(comment_id: singleComment.id).order('points DESC').all
    @comReplies.each do |rep, i|
      setRep = Set[]
      setRep.add(rep)
      if !@commentsAlreadyUsed.subset?(setRep)
        repliesCompleted.add(funcio(rep))
      end
    end
    #nou per al client frontend
    comment_author_username = User.find(singleComment.user_id).username
    
    return CommentComplete.new(singleComment, repliesCompleted, comment_author_username)
  end
  
  def getUserNews 
    respond_to do |format|
      if request.headers['token'].present?
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
          @commentsAlreadyUsed = Set[]
          @userNews = nil
          if User.exists?(params[:id])  #si existeix el user especificat
            @result = Set[]
            @userNews = New.where(:user_id => params[:id]).order('points DESC').all
            @userNews.each do |new, i|
              @resultpartial = Set[]
              @newComments = Comment.where(:new_id => new.id).order('points DESC').all
              @newComments.each do |com, i|
                if com.comment_id.nil?
                  @resultpartial.add(funcio(com))
                end
              end
              #nou per al client frontend
              author_username = User.find(new.user_id).username
              
              @result.add(NewComplete.new(new, @resultpartial, author_username))
            end
            format.json { render json: @result, status: :ok}
          else
            format.json { render json: {error: "error", code: 404, message: "The user with ID: " + params[:id] + " doesn't exist"}, status: :not_found}
          end  
        else
          format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else
        format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
      end
    end
  end
  
end