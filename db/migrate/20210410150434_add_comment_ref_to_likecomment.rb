class AddCommentRefToLikecomment < ActiveRecord::Migration[6.1]
  def change
    add_reference :likecomments, :comment, null: false, foreign_key: true
  end
end
