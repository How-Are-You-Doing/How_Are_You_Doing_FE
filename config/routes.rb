Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#welcome'
  post 'auth/google_oauth2/callback', to: 'sessions#create'
  # resources :sessions, only: %i[create]
end
