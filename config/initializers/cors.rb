Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :delete, :put]
    
    #es pot especificar mes. per ex, permetre nomes alguns metodes a certs resources.
  end
end