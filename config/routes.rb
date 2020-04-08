Rails.application.routes.draw do
  root 'home#index'

  # Resources
  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  # Home Controller
  get 'home/index'
  get 'home/dashboard'

  # Users
  get 'signup', to: 'users#new', as: 'signup'

  # Sessions
  get 'login', to: 'sessions#new', as: 'login'
  post 'sessions/create'
  get 'logout', to: 'sessions#destroy', as: 'logout'
end
