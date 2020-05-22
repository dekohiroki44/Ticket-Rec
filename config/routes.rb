Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    # get 'signup', to: 'devise/registrations#new'
    # post 'signup', to: 'devise/registrations#create'
    # get 'login', to: 'devise/sessions#new'
    # post 'login', to: 'devise/sessions#create'
    # delete 'logout', to: 'devise/sessions#destroy'
  end
  root to: "static_pages#home"
  get '/about', to: 'static_pages#about'
end
