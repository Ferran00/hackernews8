class NewController < ApplicationController
  def index
    @new = New.order('created_at DESC').all
    @userliked = nil
    if !current_user.nil?
      @userliked = Likenew.where(user_id: session[:user_id]).all
    end
    @paginanewest = true
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
    redirect_to :newest
  end    
  
  def unvote
    Likenew.find_by(user_id: current_user.id, new_id: params[:newid]).destroy
    @publi = New.find(params[:newid])
    @publi.points -=1
    @publi.save
    @user = User.find(@publi.user_id)
    @user.karma -=1
    @user.save
    redirect_to :newest
  end
  
  def getNComments(newID)
    return Comment.where(new_id: newID).all.size
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