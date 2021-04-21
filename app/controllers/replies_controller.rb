class RepliesController < ApplicationController
  def index
    @parent = Comment.find(params[:id])
    @textError = params[:error]
  end
  
  def createReply
    if !params[:text].blank?
      
      thread_id = getThreadId(Comment.find(params[:comment_id]))
      
      @comment = Comment.new(text: params[:text], points: 0, user_id: current_user.id, comment_id: params[:comment_id], new_id: thread_id) #tenim hardcodejat usuari 1, ojo amb tenir un usuari
      @comment.save
      
      new_id2 = Comment.find(params[:comment_id]).new_id
    
      redirect_to controller: 'news', action: 'item', id: new_id2  
    else
      #redirigir a pagina d'error
      redirect_to controller: "replies", action: "index", id: params[:comment_id], error: 1
    end
  end
  
  def getThreadTitle(currentComment)
    return New.find(getThreadId(currentComment)).title
  end
  
  helper_method :getThreadTitle
  
  #thread vol dir el "new" en el que es troben els comentaris
  def getThreadId(currentComment)
    current_new_id = currentComment.new_id
    while current_new_id.nil?
      currentComment = Comment.find(currentComment.comment_id)
      current_new_id = currentComment.new_id
    end 
    return current_new_id
  end
  
  helper_method :getThreadId
  
end
