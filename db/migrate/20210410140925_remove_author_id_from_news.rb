class RemoveAuthorIdFromNews < ActiveRecord::Migration[6.1]
  def change
    remove_column :news, :authorId, :integer
  end
end
