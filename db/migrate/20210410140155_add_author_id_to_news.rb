class AddAuthorIdToNews < ActiveRecord::Migration[6.1]
  def change
    add_column :news, :authorId, :integer
  end
end
