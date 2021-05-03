class User < ApplicationRecord
  def generate_api_key
    SecureRandom.base58(24)
  end
  
  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    
    where(email: auth.info.email).first_or_initialize do |user|
      user.api_key = user.generate_api_key
      user.id = auth.uid
      user.username = auth.info.name
      user.email = auth.info.email
      user.karma = 0
    end
  end
end
