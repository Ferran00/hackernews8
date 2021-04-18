Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "news#index"
  post "/submit", to: "submit#create"
  get "/news", to: "news#index"
  get "/newest", to: "new#index"
  get "/submit", to: "submit#index"
  get "/item", to: "news#item"
  post "/item", to: "news#createComment"
  # Routes for Google authentication
  get "auth/:provider/callback", to: "sessions#googleAuth"
  get "auth/failure", to: redirect('/')
  end