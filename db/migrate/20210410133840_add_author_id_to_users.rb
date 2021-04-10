class AddAuthorIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :authorId, :string
  end
end
