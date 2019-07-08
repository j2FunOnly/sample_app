Rails.application.routes.draw do
  root 'static_pages#home'

  # get '/help', to: 'static_pages#help'
  match '/help', to: 'static_pages#help', via: :get
  get '/about', to: 'static_pages#about', as: :about
  get '/contact', to: 'static_pages#contact'

  resources :users
  get '/signup', to: 'users#new'

  resources :sessions, only: [:new, :create, :destroy]
  get '/signin', to: 'sessions#new'
  delete '/signout', to: 'sessions#destroy'

  resources :microposts, only: [:create, :destroy]
end
