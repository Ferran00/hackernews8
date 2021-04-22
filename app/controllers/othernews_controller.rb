class OthernewsController < ApplicationController
  def index
    @otherUserNews = New.where(:user_id => params[:userid]).order('points DESC').all
    @userliked = Likenew.where(user_id: session[:user_id]).all
    render "news/othernews"
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