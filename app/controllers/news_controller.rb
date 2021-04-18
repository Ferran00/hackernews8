class NewsController < ApplicationController
  def index
    @new = New.where("isurl == 1").order('points DESC').all
    @paginanewest = false
  end
  
  def item
    @ask = New.find(params[:id])
    @comments = Comment.where("new_id == @ask.id").all#.count
  end
  
  def createComment
    if !params[:text].blank?
      @comment = Comment.new(text: params[:text], points: 0, user_id: 1, new_id: params[:new_id]) #tenim hardcodejat usuari 1, ojo amb tenir un usuari
      @comment.save
      #else redirigir a pagina d'error
    end
    redirect_to controller: 'news', action: 'item', id: params[:new_id]
  end
  
end