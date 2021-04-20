class NewsController < ApplicationController
  def index
    @new = New.where(:isurl => 1).order('points DESC').all
    @paginanewest = false
  end
  
  def item
    @ask = New.find(params[:id])
    @comments = Comment.where("new_id == @ask.id").all#.count
    if params[:error].nil?
      @textError = 0
    else
      @textError = params[:error]
    end
  end
  
  def createComment
    if !params[:text].blank?
      @comment = Comment.new(text: params[:text], points: 0, user_id: 1, new_id: params[:new_id]) #tenim hardcodejat usuari 1, ojo amb tenir un usuari
      @comment.save
      redirect_to controller: 'news', action: 'item', id: params[:new_id]
    else
      redirect_to controller: "news", action: "item", id: params[:new_id], error: 1
    end
  end
  
  def vote
    Likenew.new(user_id: params[:userid], new_id: params[:newid])
    publi = New.where(new_id: params[:newid])
    point = publi.points
    publi.update_attribute :points, publi+1
    redirect_to :news
  end    
  
  def unvote
    Likenew.where(:user_id => params[:userid]).where(:new_id => params[:newid]).delete
    publi = New.where(new_id: params[:newid])
    point = publi.points
    publi.update_attribute :points, publi-1
    redirect_to :news
  end
  
  def vote_item
    Likenew.new(user_id: params[:userid], new_id: params[:newid])
    publi = New.where(new_id: params[:newid])
    point = publi.points
    publi.update_attribute :points, publi+1
    redirect_to :item
  end    
  
  def unvote_item
    Likenew.where(:user_id => params[:userid]).where(:new_id => params[:newid]).delete
    publi = New.where(new_id: params[:newid])
    point = publi.points
    publi.update_attribute :points, publi-1
    redirect_to :item
  end
  
  def vote_comment
    Likecomment.new(user_id: params[:userid], comment_id: params[:commentid])
    com = Comment.where(comment_id: params[:commentid])
    point = com.points
    com.update_attribute :points, com+1
    redirect_to :item
  end    
  
  def unvote_comment
    Likecomment.where(:user_id => params[:userid]).where(:comment_id => params[:commentid]).delete
    com = Comment.where(comment_id: params[:commentid])
    point = com.points
    com.update_attribute :points, com-1
    redirect_to :item
  end
  
  def getNComments(newID)
    return Comment.where(new_id: newID).all.size
  end
  
  def getNCommentsIncludingReplies(newID)
    
  end
  
  def getNCommentsString(newID)
    n_comments = getNComments(newID)
    if n_comments == 0
      return "discuss"
    else
      return n_comments.to_s + " comments"
    end
  end
  helper_method :getNCommentsString
  
end