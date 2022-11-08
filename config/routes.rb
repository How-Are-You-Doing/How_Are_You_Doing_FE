Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#welcome'
  get 'auth/google_oauth2/callback', to: 'sessions#create'
  get '/logout', to: "sessions#destroy", as: :logout
  get '/friends/:google_id/posts', to: 'friends#show'
  get '/history', to: 'posts#index'
  delete '/posts/:id', to: 'posts#destroy'
  # resources :sessions, only: %i[create]
  resource :dashboard, only: %i[show]
  resources :friends, only: [:index, :create]
  resource :post, only: %i[update destroy edit]
  resources :posts, only: %i[index]
end
