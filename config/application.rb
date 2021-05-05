require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hackernews8ferran
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.autoloader = :classic
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.assets.initialize_on_precompile = false
    
    
    #CORS. això se suposa que és per a rails 5, però és el que s'esperen els profes. (idk) -Ferran
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :delete, :put, :options]  #options no el farem servir per res però en l'exemple el posaven. xd
        
        #es pot especificar mes. per ex, permetre nomes alguns metodes a certs resources.
      end
    end
    
  end
end
