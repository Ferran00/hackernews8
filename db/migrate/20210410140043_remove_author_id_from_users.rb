class RemoveAuthorIdFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :authorId, :string
  end
end
