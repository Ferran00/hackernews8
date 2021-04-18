class RepliesController < ApplicationController
  def index
    @parent = Comment.find(params[:id])
  end
  
  def createReply
    if !params[:text].blank?
      @comment = Comment.new(text: params[:text], points: 0, user_id: 1, comment_id: params[:comment_id]) #tenim hardcodejat usuari 1, ojo amb tenir un usuari
      @comment.save
      #else redirigir a pagina d'error
    end
    
    new_id2 = Comment.find(params[:comment_id]).new_id
    
    redirect_to controller: 'news', action: 'item', id: new_id2               
  end
end
