class ChangeIntegerLimitInUsers < ActiveRecord::Migration[6.1]
  def up
    change_column :Users, :id, :integer, limit: 16
  end
  
  def down
    change_column :Users, :id, :integer, limit: 8
  end
end
