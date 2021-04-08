class AddGoogleRefreshTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :google_refresh_token, :string
  end
end
