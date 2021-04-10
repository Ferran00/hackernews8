class RemoveAuthorFromNews < ActiveRecord::Migration[6.1]
  def change
    remove_column :news, :author, :string
  end
end
