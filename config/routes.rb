Rails.application.routes.draw do
  get 'settings/index'
  get 'settings/change_password'
  get 'legal/disclaimer'
  get 'legal/privacy'
  get 'legal/legal_note'
  resources :payments
  resources :loans
  resources :people
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
