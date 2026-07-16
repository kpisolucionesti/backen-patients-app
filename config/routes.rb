Rails.application.routes.draw do
  devise_for :users, skip: :all

  resources :patients do
    collection do
      get :find_by_ci
    end
    member do
      get :stats
    end
    resources :allergies, controller: 'patient_allergies', only: [:index, :create, :update, :destroy]
    resources :antecedents, controller: 'patient_antecedents', only: [:index, :create, :update, :destroy]
  end
  resources :doctors
  resources :rooms
  resources :notes
  resources :emergencies do
    resources :medical_plans, only: [:index, :create, :update, :destroy]
    resources :vital_signs, only: [:index, :create]
    resources :interconsultations, only: [:index, :create, :update, :destroy]
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
      get :activity_logs, to: 'user_activity_logs#index'
    end
    collection do
      get :profiles
    end
  end

  resources :tv_screens do
    collection do
      post :auth
      get :list_active
    end
    member do
      post :regenerate_pin
      post :revoke_sessions
    end
    resources :events, only: [:index], controller: 'tv_screen_events'
  end

  resources :permissions, only: [:index]

  resource :email_settings, only: [:show, :update] do
    post :test
  end

  get 'dashboard/stats', to: 'dashboard#stats'

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post "sign_up",  to: "registrations#create"
        post "sign_in",  to: "sessions#create"
        delete "sign_out", to: "sessions#destroy"
        post "forgot_password", to: "passwords#create"
        put "reset_password",   to: "passwords#update"
        post "keep_alive", to: "sessions#keep_alive"
      end
    end
  end
end
