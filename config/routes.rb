Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "sessions#new"

  match   "/404",                   to: "errors#not_found",             via: :all
  match   "/422",                   to: "errors#unprocessable",         via: :all
  match   "/500",                   to: "errors#internal_server_error", via: :all

  get     "/my-application",        to: "job_applications#mine",        as: :my_applications
  get     "/my-posted-jobs",        to: "jobs#mine",                    as: :my_posted_jobs

  get     "/signup",                to: "registrations#new"
  post    "/signup",                to: "registrations#create"

  get     "/login",                 to: "sessions#new",                 as: :login
  post    "/login",                 to: "sessions#create"
  delete  "/logout",                to: "sessions#destroy",             as: :logout

  get     "/forgot-password",       to: "password_resets#new",          as: :forgot_password
  post    "/forgot-password",       to: "password_resets#create"
  get     "/reset-password/:token", to: "password_resets#edit",         as: :reset_password
  patch   "/reset-password/:token", to: "password_resets#update"

  resources :registrations, only: [:new, :create]
  resources :developers,    only: [:index, :show]
  resources :clients,       only: [:index, :show]

  resources :users,         only: [:index, :show, :edit, :update, :destroy] do
    member do
      patch :make_admin
    end
  end

  resources :jobs do
    member do
      patch :complete
    end

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
