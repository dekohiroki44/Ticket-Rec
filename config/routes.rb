Rails.application.routes.draw do
  get 'likes/create'
  get 'likes/destroy'
  get 'events/new'
  get 'events/show'
  get 'events/edit'
  root to: "static_pages#home"
  get '/about', to: 'static_pages#about'
  devise_for :users
  resources :users, only: [:show]
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :events do
    resources :comments, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  # devise_scope :user do
  #   # get 'signup', to: 'devise/registrations#new'
  #   # post 'signup', to: 'devise/registrations#create'
  #   # get 'login', to: 'devise/sessions#new'
  #   # post 'login', to: 'devise/sessions#create'
  #   # delete 'logout', to: 'devise/sessions#destroy'
  # end
end
