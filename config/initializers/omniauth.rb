OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.allowed_request_methods = [:post, :get]
  provider :google_oauth2, '364404659559-amubpqehmj82f7ieght4eoh2uj3sbofd.apps.googleusercontent.com', 'yMYSK-4fBNoYg0tT2fCfA2sT', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}

end