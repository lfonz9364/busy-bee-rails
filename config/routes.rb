Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "sessions#new"

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
  
  resources :developers,  only: [:index, :show]
  resources :clients,     only: [:index, :show]
  resources :users,       only: [:index, :show]
  resources :jobs
end
