Rails.application.routes.draw do
  root 'posts#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/signup', to: 'registrations#new'
  post '/signup', to: 'registrations#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  match '/upvote_post/:id', to: 'posts#upvote', via: %i[get post], as: 'upvote_post'
  match '/downvote_post/:id', to: 'posts#downvote', via: %i[get post], as: 'downvote_post'

  match '/upvote_comment/:id', to: 'comments#upvote', via: %i[get post], as: 'upvote_comment'
  match '/downvote_comment/:id', to: 'comments#downvote', via: %i[get post], as: 'downvote_comment'

  match '/save_post/:id', to: 'posts#save', via: %i[get post], as: 'save_post'

  match '/save_comment/:id', to: 'comments#save', via: %i[get post], as: 'save_comment'

  match '/archive_post/:id', to: 'posts#archive', via: %i[get post], as: 'archive_post'

  match '/publish_post/:id', to: 'posts#publish', via: %i[get post], as: 'publish_post'

  resources :comments do
    member do
      post :reply
    end
  end

  resources :posts do
    resources :comments, only: %i[create]
  end

  resources :users, param: :username, only: %i[show edit update]

  get '/search', to: 'search#index'

  get '/communities/list', to: 'communities#list'

  resources :communities, param: :name, only: %i[show index create]
  get '/new_community', to: 'communities#new'
  post '/new_community', to: 'communties#create'

  match '/join_community/:name', to: 'communities#join', via: %i[get post], as: 'join_community'

  match '/follow_user/:username', to: 'users#follow', via: %i[get post], as: 'follower'
end
