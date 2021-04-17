class CreateNews < ActiveRecord::Migration[6.1]
  def change
    create_table :news do |t|
      t.string :title
      t.string :url
      t.text :text
      t.integer :isurl
      t.integer :points
      t.string :author

      t.timestamps
    end
    # add_foreign_key :news, :users, column: :author    #by Ferran. ni idea de si funciona
  end
end
