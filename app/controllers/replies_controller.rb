class RepliesController < ApplicationController
  def index
    @parent = Comment.find(params[:id])
    @textError = params[:error]
    @userlikedCom = nil
    if !current_user.nil?
      @userlikedCom = Likecomment.where(user_id: session[:user_id]).all
    end
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
  
  
  #per a anar a comments d'un altre user fer:
  #<%= link_to "comments", '/threads?userid='+ID_DEL_USER.to_s %>
  # i entrarà al if
  def threads
    if current_user.nil?
      @userComment = Comment.where(:user_id => params[:userid]).order('points DESC').all
    else
      @userComment = Comment.where(:user_id => current_user.id).order('points DESC').all #es fa aixi el current_user? sembla que sí.
    end
    
    @paginanewest = false
    
    render "threads/index"
  end

#trash
  # <%= link_to "nom del botó", :controller => :replies, :action => :otherUserComments, userid: ID_DEL_USER %>
  
end
