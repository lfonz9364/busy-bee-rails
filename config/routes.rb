Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "jobs#index"

  resources :developers,  only: [:show, :index]
  resources :clients,     only: [:show, :index]


end
