class AddUserRefToLikenews < ActiveRecord::Migration[6.1]
  def change
    add_reference :likenews, :user, null: false, foreign_key: true
  end
end
