Rails.application.routes.draw do
  devise_for :users, skip: :all

  resources :patients do
    collection do
      get :find_by_ci
    end
  end
  resources :doctors
  resources :rooms
  resources :notes
  resources :emergencies do
    resources :medical_plans, only: [:index, :create, :update, :destroy]
  end
  resources :profiles do
    member do
      get :users
    end
  end
  resources :users do
    member do
      put :change_password
      put :update_permissions
      get :emergencies
    end
    collection do
      get :profiles
    end
  end

  resources :permissions, only: [:index]

  resource :email_settings, only: [:show, :update] do
    post :test
  end

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post "sign_up",  to: "registrations#create"
        post "sign_in",  to: "sessions#create"
        delete "sign_out", to: "sessions#destroy"
        post "forgot_password", to: "passwords#create"
        put "reset_password",   to: "passwords#update"
      end
    end
  end
end
