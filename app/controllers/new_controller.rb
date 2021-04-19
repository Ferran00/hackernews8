class NewController < ApplicationController
  def index
    @new = New.order('created_at DESC').all
    if !current_user.nil?
      @userliked = Likenew.where(user_id: session.user_id).all
    end
    @paginanewest = true
  end
  
  def vote
    #comprobar sesion
    if !current_user.nil?
      Likenew.new(user_id: params[:userid], new_id: params[:newid])
      redirect_to :new
    end
  end    
  
  def unvote
    if !current_user.nil?
      Likenew.where(:user_id => params[:userid]).where(:new_id => params[:newid]).delete
      redirect_to :new
    end
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