class AddNewRefToComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :comments, :new, null: true, foreign_key: true
  end
end
