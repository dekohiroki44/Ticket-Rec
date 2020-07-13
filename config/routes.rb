Rails.application.routes.draw do
  root to: "static_pages#home"
  get '/about', to: 'static_pages#about'
  get '/tos', to: 'static_pages#tos'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end
  resources :users do
    member do
      get :following, :followers, :map, :recommend
    end
  end
  resources :users, only: [:show]
  resources :tickets do
    member do
      patch :unsolved
    end
    resources :comments, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :notifications, only: [:index]
  resources :searches, only: [:index]
end
