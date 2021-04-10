class CreateLikecomments < ActiveRecord::Migration[6.1]
  def change
    create_table :likecomments do |t|

      t.timestamps
    end
  end
end
