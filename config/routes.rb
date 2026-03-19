Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "sessions#new"

  get "/my-application", to: "job_applications#mine", as: :my_applications
  get  "/signup", to: "registrations#new"
  post "/signup", to: "registrations#create"

  get "/login",             to: "sessions#new",     as: :login
  post "/login",            to: "sessions#create"
  delete "/logout",         to: "sessions#destroy", as: :logout
  
  resources :registrations, only: %i[new create]
  resources :developers,    only: [:index, :show]
  resources :clients,       only: [:index, :show]

  resources :users,         only: [:index, :show, :edit, :update] do
    member do
      patch :make_admin
    end
  end

  resources :jobs do
    resources :feedbacks,         only: [:new, :create]
    resources :job_applications,  only: [:create]
  end

  resources :feedbacks,           only: [:index, :show, :edit, :update, :destroy]

  resources :job_applications,    only: [] do
    member do
      patch :accept
      patch :decline
    end
  end
end
