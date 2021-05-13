class Api::CommentsController < ApplicationController
  
    
  CommentComplete = Struct.new(:comment, :replies) do
  end
  
  
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
            format.json { render json: {error: "error", code: 400, message: "The text or the comment_id provided are blank"}, status: :bad_request}
          end
        else
          format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else
        format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
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
            @comment = Comment.new(text: params[:text], points: 0, user_id: @user.id, new_id: params[:new_id])
            @comment.save
            format.json { render json: @comment, status: :ok}
          else
            format.json { render json: {error: "error", code: 400, message: "The text or the new_id provided are blank"}, status: :bad_request}
          end
        else
          format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else
        format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
      end
    end
  end
  
  
  def upvote
    respond_to do |format|
      
      if !params[:comment_id].nil? #si han passat el param
      
        if request.headers['token'].present?  #si hi ha token
          @key = request.headers['token'].to_s
          if User.exists?(api_key: @key)  #token valid. identifica al user.
            @user  = User.find_by(api_key: @key)
            if (!Likecomment.exists?(user_id: @user.id, comment_id: params[:comment_id]))  #si no està liked
              @like = Likecomment.new(user_id: @user.id, comment_id: params[:comment_id])
              @like.save
              @com = Comment.find(params[:comment_id])
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
          format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
        end
        
      else #no han passat el param comment_id
        format.json { render json:{status:"error", code:400, message: "No comment_id specified (query)"}, status: :bad_request}
      end
    end
  end
  
  def unvote
    respond_to do |format|
      
      if !params[:comment_id].nil? #si han passat el param
      
        if request.headers['token'].present?  #si hi ha token
          @key = request.headers['token'].to_s
          if User.exists?(api_key: @key)  #token valid. identifica al user.
            @user  = User.find_by(api_key: @key)
            
            if (Likecomment.exists?(user_id: @user.id, comment_id: params[:comment_id]))  #si està liked
              Likecomment.find_by(user_id: @user.id, comment_id: params[:comment_id]).destroy
              @com = Comment.find(params[:comment_id])
              @com.points -=1
              @com.save
              @author = User.find(@com.user_id)
              @author.karma -=1
              @author.save
              format.json { render json:{status:"No content", code:204, message: "Comment with ID '" + params[:comment_id] + "' unvoted successfully"}, status: :no_content} #no retorna el status i el message perque "pel que es veu" 204 is not supposed to return a body
            else
              format.json { render json:{status:"error", code:404, message: "User has not upvoted a comment with ID '" + params[:comment_id] + "'"}, status: :not_found}
            end
          else  #token no valid
            format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
          end
        else  #no han pasado token
          format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
        end
        
      else #no han passat el param comment_id
        format.json { render json:{status:"error", code:400, message: "No comment_id specified (query)"}, status: :bad_request}
      end
     end
    
  end
  
  def funcio(singleComment)
    repliesCompleted = Set[]
    @commentsAlreadyUsed.add(singleComment)
    @comReplies = Comment.where(comment_id: com.id).order('points DESC').all
    @comReplies.each do |rep, i|
      if not @commentsAlreadyUsed.exists(rep)
        repliesCompleted.add(funcio(rep))
      end
    end
    return CommentComplete.new(com, repliesCompleted)
  end
  
  def threads
    respond_to do |format|
      if request.headers['token'].present?  #si hi ha token
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)  #token valid. identifica al user.
          @commentsAlreadyUsed = Set[]
          @userComments = nil
          if User.exists?(params[:id])  #si existeix el user especificat
            @result = Set[]
            @userComments = Comment.where(:user_id => params[:id]).order('points DESC').all
            @userComments.each do |com, i|
              @result.add(funcio(com))
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
  
  
  def getThreadId(currentComment)
    current_new_id = currentComment.new_id
    while current_new_id.nil?
      currentComment = Comment.find(currentComment.comment_id)
      current_new_id = currentComment.new_id
    end 
    return current_new_id
  end
  
  
  def commentsUpvotedByUser
    respond_to do |format|
      
      if request.headers['token'].present?  #si hi ha token
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)  #token valid. identifica al user.
          @user = User.find_by(api_key: @key)
          
          @likedComments = Set[]
          @likecomment = Likecomment.where(:user_id => @user.id).all
          @likecomment.each_with_index do |lc,i|
            comment = Comment.find(lc.comment_id)
            @likedComments.add(comment)
          end
          
          format.json { render json: @likedComments, status: :ok}
            
        else  #token no valid
            format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else  #no han pasado token
          format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
      end
    end
  end
  
end

