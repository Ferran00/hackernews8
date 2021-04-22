class UpvotedController < ApplicationController
  def index
    @likedComment = Likecomment.where(:user_id => current_user.id).all
  end
  
  def getThreadTitle(currentComment)
    return New.find(getThreadId(currentComment)).title
  end
  
  helper_method :getThreadTitle
  
  #thread vol dir el "new" en el que es troben els comentaris
  def getThreadId(currentComment)
    current_new_id = currentComment.new_id
    while current_new_id.nil?
      currentComment = Comment.find(currentComment.comment_id)
      current_new_id = currentComment.new_id
    end 
    return current_new_id
  end
  
  helper_method :getThreadId
  
end