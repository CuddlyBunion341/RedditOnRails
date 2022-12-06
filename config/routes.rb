Rails.application.routes.draw do
  root "post#index"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
end
