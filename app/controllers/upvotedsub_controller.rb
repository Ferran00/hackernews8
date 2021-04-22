class UpvotedsubController < ApplicationController
  def index
    @likedSubmission = Likenew.where(:user_id => current_user.id).all
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