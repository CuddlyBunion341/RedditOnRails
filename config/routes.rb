Rails.application.routes.draw do
  root "posts#index"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"
  delete "logout", to: "sessions#destroy"
  get "post", to: "posts#new"
  post "post", to: "posts#create"

  post "upvote/:id", to: "posts#upvote"
  post "downvote/:id", to: "posts#downvote"
end
