Rails.application.routes.draw do
  root to: "static_pages#home"
  get '/about', to: 'static_pages#about'
  devise_for :users
  resources :users, only: [:show]
  resources :users do
    member do
      get :following, :followers, :map
    end
  end
  resources :tickets do
    resources :comments, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :notifications, only: [:index]
  resources :searches, only: [:index]
end
