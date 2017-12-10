Rails.application.routes.draw do
  resources :followers

  resources :boards

  resources :users, except: [:index]
  get '/signup' => "users#new", as: :signup
  get '/login' => "users#login", as: :login
  post '/login' => "users#authenticate"
  delete '/logout:id' => "users#logout", as: :logout
  post "pins/repin/:id" => "pins#repin", as: 'repin'

  root 'pins#index'
  get "pins/name-:slug" => "pins#show_by_name", as: "pin_by_name"
  resources :pins

  get '/library' => "pins#index"