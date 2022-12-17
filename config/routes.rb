Rails.application.routes.draw do
  root "posts#index"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"
  delete "logout", to: "sessions#destroy"
  get "post", to: "posts#new"
  post "post", to: "posts#create"

  match "upvote_post/:id", to: "posts#upvote", via: [:get, :post], as: "upvote_post"
  match "downvote_post/:id", to: "posts#downvote", via: [:get, :post], as: "downvote_post"

  # add routes for users
  resources :users, only: [:show, :index]
end
