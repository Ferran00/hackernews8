class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :text
      t.integer :points

      t.timestamps
    end
  end
end
