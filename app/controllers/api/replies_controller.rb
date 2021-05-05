class Api::RepliesController < ApplicationController
  def createReply
    respond_to do |format|  
      if request.headers['token'].present?
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
          if !params[:text].blank?
            thread_id = getThreadId(Comment.find(params[:comment_id]))
            @user = User.find_by(api_key: @key)
            @comment = Comment.new(text: params[:text], points: 0, user_id: @user.id, comment_id: params[:comment_id], new_id: thread_id) 
            @comment.save
            format.json { render json: @comment, status: :ok}
          else
            format.json { render json: {error: "error", code: 404, message: "The text provided is blank"}, status: :not_found}
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
  
end

