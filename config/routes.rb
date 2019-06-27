Rails.application.routes.draw do
  get 'users/new'

  root 'static_pages#home'

  # get '/help', to: 'static_pages#help'
  match '/help', to: 'static_pages#help', via: :get
  get '/about', to: 'static_pages#about', as: :about
  get '/contact', to: 'static_pages#contact'

  get '/signup', to: 'users#new'
end
