Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Judge::Engine => '/judge'
  resources :requests
  root 'requests#index'
  get '/queue',		to: 	'queue#queue'
  get '/whatis',	to: 	'static#whatis'
  get '/help',		to: 	'static#help'
  authenticated :user do
	  get '/player',	to: 	'player#player'
  end
  get '/player', to: redirect('/users/sign_in')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
