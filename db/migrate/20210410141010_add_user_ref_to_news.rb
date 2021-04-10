class AddUserRefToNews < ActiveRecord::Migration[6.1]
  def change
    add_reference :news, :user, null: true, foreign_key: true
  end
end
