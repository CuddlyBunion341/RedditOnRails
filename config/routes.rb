Rails.application.routes.draw do
  root "post#index"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"
  delete "logout", to: "sessions#destroy"
  get "post", to: "post#new"
  post "post", to: "post#create"
end
