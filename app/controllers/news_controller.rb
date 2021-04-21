class NewsController < ApplicationController
  def index
    @new = New.where(:isurl => 1).order('points DESC').all
     @userliked = nil
    if !current_user.nil?
      @userliked = Likenew.where(user_id: session[:user_id]).all
    end
    @paginanewest = false
   
  end
  
  def vote
    @like = Likenew.new(user_id: current_user.id, new_id: params[:newid])
    @like.save
    @publi = New.find(params[:newid])
    @publi.points +=1
    @publi.save
    @user = User.find(@publi.user_id)
    @user.karma +=1
    @user.save
    redirect_to :news
  end    
  
  def unvote
    Likenew.find_by(user_id: current_user.id, new_id: params[:newid]).destroy
    @publi = New.find(params[:newid])
    @publi.points -=1
    @publi.save
    @user = User.find(@publi.user_id)
    @user.karma -=1
    @user.save
    redirect_to :news
  end
  
  def item
    @ask = New.find(params[:id])
    @comments = Comment.where("new_id == @ask.id").all#.count
    if params[:error].nil?
      @textError = 0
    else
      @textError = params[:error]
    end
    @userlikedCom = nil
    if !current_user.nil?
      @userlikedCom = Likecomment.where(user_id: session[:user_id]).all
    end
  end
  
  def createComment
    if !params[:text].blank?
      @comment = Comment.new(text: params[:text], points: 0, user_id: current_user.id, new_id: params[:new_id]) #tenim hardcodejat usuari 1, ojo amb tenir un usuari
      @comment.save
      redirect_to controller: 'news', action: 'item', id: params[:new_id]
    else
      redirect_to controller: "news", action: "item", id: params[:new_id], error: 1
    end
  end

  
  def votecomment
    @likeComment = Likecomment.new(user_id: current_user.id, comment_id: params[:comment_id])
    @likeComment.save
    @com = Comment.find(params[:comment_id])
    @com.points += 1
    @com.save
    redirect_to controller: 'news', action: 'item', id: @com.new_id
    
  end    
  
  def unvotecomment
    Likecomment.find_by(user_id: current_user.id, comment_id: params[:comment_id]).destroy
    @com = Comment.find(params[:comment_id])
    @com.points -= 1
    @com.save
    redirect_to controller: 'news', action: 'item', id: @com.new_id
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
  
  def ask
    @ask = New.where(:isurl => 0).order('points DESC').all
     @userliked = nil
    if !current_user.nil?
      @userliked = Likenew.where(user_id: session[:user_id]).all
    end
    @paginanewest = false
    
    render "ask/index"
  end
  
end