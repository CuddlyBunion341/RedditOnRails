Rails.application.routes.draw do
  root "posts#index"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"
  delete "logout", to: "sessions#destroy"

  get "create_post", to: "posts#new"
  post "create_post", to: "posts#create"

  match "upvote_post/:id", to: "posts#upvote", via: [:get, :post], as: "upvote_post"
  match "downvote_post/:id", to: "posts#downvote", via: [:get, :post], as: "downvote_post"

  match "save_post/:id", to: "posts#save", via: [:get, :post], as: "save_post"

  resources :users, only: [:show, :index]

  resources :posts do
    resources :comments, only: [:create]
  end
end
