class NewsController < ApplicationController
  def index
    @new = New.where(:isurl => 1).order('points DESC').all
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
  
  def vote
    Likenew.new(user_id: params[:userid], new_id: params[:newid])
    redirect_to :news
  end    
  
  def unvote
    Likenew.where(:user_id => params[:userid]).where(:new_id => params[:newid]).delete
    redirect_to :news
  end
  
  def vote_item
    Likenew.new(user_id: params[:userid], new_id: params[:newid])
    redirect_to :item
  end    
  
  def unvote_item
    Likenew.where(:user_id => params[:userid]).where(:new_id => params[:newid]).delete
    redirect_to :item
  end
  
  def vote_comment
    Likecomment.new(user_id: params[:userid], comment_id: params[:commentid])
    redirect_to :item
  end    
  
  def unvote_comment
    Likecomment.where(:user_id => params[:userid]).where(:comment_id => params[:commentid]).delete
    redirect_to :item
  end
end