class Api::RepliesController < ApplicationController
  def createReply
    respond_to do |format|  
      if request.headers['token'].present?
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
          if !params[:text].blank? && !params[:comment_id].blank?
            thread_id = getThreadId(Comment.find(params[:comment_id]))
            @user = User.find_by(api_key: @key)
            @comment = Comment.new(text: params[:text], points: 0, user_id: @user.id, comment_id: params[:comment_id], new_id: thread_id) 
            @comment.save
            format.json { render json: @comment, status: :ok}
          else
            format.json { render json: {error: "error", code: 404, message: "The text or the comment_id provided are blank"}, status: :not_found}
          end
        else
            format.json { render json: {error: "error", code: 404, message: "The user with token: " + @key + " doesn't exist"}, status: :not_found}
        end
      else
        format.json { render json:{status:"error", code:403, message: "The autentication token is not provided"}, status: :forbidden}
      end
    end
  end

  def createComment
    respond_to do |format|  
      if request.headers['token'].present?
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
          if !params[:text].blank? && !params[:new_id].blank?
            @user = User.find_by(api_key: @key)
            @comment = Comment.new(text: params[:text], points: 0, user_id: @user.id, new_id: params[:new_id]) #tenim hardcodejat usuari 1, ojo amb tenir un usuari
            @comment.save
            format.json { render json: @comment, status: :ok}
          else
            format.json { render json: {error: "error", code: 404, message: "The text or the new_id provided are blank"}, status: :not_found}
          end
        else
            format.json { render json: {error: "error", code: 404, message: "The user with token: " + @key + " doesn't exist"}, status: :not_found}
        end
      else
        format.json { render json:{status:"error", code:403, message: "The autentication token is not provided"}, status: :forbidden}
      end
    end
  end
   
  def getThreadId(currentComment)
    current_new_id = currentComment.new_id
    while current_new_id.nil?
      currentComment = Comment.find(currentComment.comment_id)
      current_new_id = currentComment.new_id
    end 
    return current_new_id
  end
  
  def upvote
    respond_to do |format|
      
      if !params[:comment_id].nil? #si han passat el param
      
        if request.headers['token'].present?  #si hi ha token
          @key = request.headers['token'].to_s
          if User.exists?(api_key: @key)  #token valid. identifica al user.
            @user  = User.find_by(api_key: @key)
            if (!Likecomment.exists?(user_id: @user.id, comment_id: params[:comment_id]))  #si no està liked
              @like = Likecomment.new(user_id: current_user.id, comment_id: params[:comment_id])
              @like.save
              @com = New.find(params[:comment_id])
              @com.points +=1
              @com.save
              @author = User.find(@com.user_id)
              @author.karma +=1
              @author.save
              format.json { render json:{status:"OK", code:200, message: "Comment with ID '" + params[:comment_id] + "' upvoted successfully"}, status: :ok}  #el status: :ok nidea de si funcionarà
            else   #si ja esta liked
              format.json { render json:{status:"error", code:409, message: "Comment with ID '" + params[:comment_id] + "' has already been upvoted by user"}, status: :conflict} #el status: :conflict nidea de si funcionarà
            end
          else  #token no valid
            format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
          end
        else  #no han pasado token
          format.json { render json:{status:"error", code:401, message: "no API key provided"}, status: :unauthorized}
        end
        
      else #no han passat el param newid
        format.json { render json:{status:"error", code:400, message: "no comment_id specified (query)"}, status: :bad_request}
      end
    end
  end
  
 
  
end
