Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "news#index"
  post "/submit", to: "submit#create"
  post "/new/vote/:newid", to: "new#vote"
  delete "/new/unvote/:newid", to: "new#unvote"
  post "/news/vote/:newid", to: "news#vote"
  delete "news/unvote/:newid", to: "news#unvote"
  post "/news/votecomment/:comment_id", to: "news#votecomment"
  delete "news/unvotecomment/:comment_id", to: "news#unvotecomment"
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
  get "/auth/logout", to: "sessions#logout"
  
  get "/ask", to: "news#ask"
  get "/threads", to: "replies#threads"
  get "threads/otherusercomments", to: "replies#threads"
 # get "threads/:userid", to: "replies#otherUserComments"
  get "/news/othernews", to: "othernews#index"
  get "/profile", to: "profile#profile"
  get "/profile/:userid", to: "otherprofile#index"
  post "/profile", to: "profile#update"
  
  get "/upvoted", to: "upvoted#index"
  get "/upvotedsub", to: "upvotedsub#index"
  
  scope "/api",defaults: {format: 'json'} do
    #news
    get "/news/:id", to: "api/news#getInfoNew"
    
    #upvote new 
    post "/news/upvote", to: "api/news#upvote"
    
    #users
    get "/users/profile", to: "api/users#getProfile"
    put "/users/profile", to: "api/users#updateProfile"
    get "/users/otherprofile", to: "api/users#getOtherProfile"
    
    #comments
    post "/reply/:comment_id", to: "api/replies#createReply"
  end
end