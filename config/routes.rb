Rails.application.routes.draw do
  root 'static_pages#home'

  # get '/help', to: 'static_pages#help'
  match '/help', to: 'static_pages#help', via: :get
  get '/about', to: 'static_pages#about', as: :about
  get '/contact', to: 'static_pages#contact'
end
