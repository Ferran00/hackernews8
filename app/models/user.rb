class User < ApplicationRecord
  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |user|
      user.id = auth.uid
      user.username = auth.info.name
      user.email = auth.info.email
      user.karma = 0
    end
  end
end
