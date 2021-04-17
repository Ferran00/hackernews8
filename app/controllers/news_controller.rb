class NewsController < ApplicationController
  def index
    @new = New.where(:isurl => 1).order('points DESC').all
    @paginanewest = false
  end
  
  def item
    @ask = New.find(params[:id])
    @comments = Comment.where("new_id == @ask.id").all#.count
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