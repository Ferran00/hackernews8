class AddNewRefToLikenews < ActiveRecord::Migration[6.1]
  def change
    add_reference :likenews, :new, null: false, foreign_key: true
  end
end
