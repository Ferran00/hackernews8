class NewController < ApplicationController
  def index
    @new = New.order('created_at DESC').all
    if !current_user.nil?
      @userliked = Likenew.where(user_id: session[:user_id]).all
    end
    @paginanewest = true
  end
  
  def vote
    #Likenew.new(user_id: params[:userid], new_id: params[:newid])
    @publi = New.find(params[:id])
    @publi.points +=1
    @publi.save
    redirect_to :newest
  end    
  
  def unvote
    # Likenew.where(:user_id => params[:userid]).where(:new_id => params[:newid]).delete
    @publi = New.find(params[:id])
    @publi.points -=1
    @publi.save
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