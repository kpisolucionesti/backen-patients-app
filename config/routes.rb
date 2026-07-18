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
  resources :areas
  resources :rooms
  resources :notes
  resources :emergencies do
    resources :medical_plans, only: [:index, :create, :update, :destroy]
    resources :vital_signs, only: [:index, :create]
    resources :interconsultations, only: [:index, :create, :update, :destroy]
    resources :paraclinical_studies, only: [:index, :create, :update, :destroy]
    resources :physical_exams, only: [:index, :create, :update]
    resources :laboratory_results, only: [:index, :show, :create, :update, :destroy]
    resource  :hospitalization, only: [:show, :create, :update] do
      member do
        post :discharge
      end
    end
  end

  resource :direct_admission, only: [:create], controller: 'direct_admissions'

  resources :hospitalizations, only: [] do
    collection do
      get :census
    end
    resources :hospitalization_notes, only: [:index, :create, :update, :destroy]
    resources :fluid_balances, only: [:index, :create, :update, :destroy] do
      collection do
        get :summary
      end
    end
    resources :medication_administrations, only: [:index, :create, :update, :destroy]
    resources :surgeries, only: [:index, :create, :update, :destroy]
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

  resources :lab_parameters, only: [:index, :create, :update, :destroy] do
    collection do
      post :import
    end
  end
  resources :lab_parameter_groups, only: [:index, :create, :update, :destroy]

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
