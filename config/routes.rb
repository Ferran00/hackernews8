Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "news#index"
  post "/submit", to: "submit#create"
  post "/new/vote:id", to: "new#vote"
  delete "/new/unvote:id", to: "new#unvote"
  post "/news/vote", to: "news#vote"
  delete "news/unvote", to: "news#unvote"
  post "/news/votecomment", to: "news#votecomment"
  delete "news/unvotecomment", to: "news#unvotecomment"
  get "/news", to: "news#index"
  get "/newest", to: "new#index"
  get "/submit", to: "submit#index"
  get "/item", to: "news#item"
  post "/item", to: "news#createComment"
  # Routes for Google authentication
  get "/auth/:provider/callback", to: "sessions#googleAuth"
  get "/auth/failure", to: redirect('/')
  
  get "/reply", to: "replies#index"
  
  
  
  post "/reply", to: "replies#createReply"
  
  end