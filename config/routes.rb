# frozen_string_literal: true

Rails.application.routes.draw do
  get 'scheduled_payments/overdues', to: 'scheduled_payments#overdues'

  resources :scheduled_payments do
    get 'check', on: :member
    post 'check_confirm', on: :member
  end

  get 'settings/index'
  get 'legal/disclaimer'
  get 'legal/privacy'
  get 'legal/legal_note'
  resources :payments
  resources :loans
  resources :people
  root 'home#index'

  # Resources
  resources :users
  resources :sessions, only: %i[new create destroy]

  # Home Controller
  get 'home/index'
  get 'home/dashboard'

  # Users
  get 'signup', to: 'users#new', as: 'signup'

  # Sessions
  get 'login', to: 'sessions#new', as: 'login'
  post 'sessions/create'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  # REST API
  namespace :api do
    post 'register', to: 'registration#register'
    post 'login', to: 'login#login'
    post 'logout', to: 'login#logout'
    post 'logout_all', to: 'login#logout_all'

    resources :people, only: %i[create index show update destroy]
  end
end
