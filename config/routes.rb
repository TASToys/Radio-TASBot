Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :requests
  root 'requests#index'
  get '/queue', to: 'queue#queue'
  get '/whatis', to: 'static#whatis'
  get '/help', to: 'static#help'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
