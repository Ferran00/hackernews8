class User < ApplicationRecord
  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |user|
                  puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      user.id = auth.uid
      puts auth.uid
      puts user.id
      user.username = auth.info.name
      user.email = auth.info.email
      puts user.username
      puts user.email
    end
  end
end
