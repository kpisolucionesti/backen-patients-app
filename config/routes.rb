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
    resources :family_antecedents, controller: 'patient_family_antecedents', only: [:index, :create, :update, :destroy]
    resources :gynecological_histories, controller: 'patient_gynecological_histories', only: [:index, :create, :update, :destroy]
    resources :lifestyle_habits, controller: 'patient_lifestyle_habits', only: [:index, :create, :update, :destroy]
    resources :surgeries, only: [:index], controller: 'patient_surgeries'
  end
  resources :doctors do
    resource :schedules, only: [:show, :update], controller: 'doctor_schedules'
  end
  resources :specialties
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
    resources :evaluations, only: [:index, :create, :update, :destroy]
    resources :recipes, only: [:index, :create, :update, :destroy]
    resource  :hospitalization, only: [:show, :create, :update] do
      member do
        post :discharge
      end
    end
  end

  resource :direct_admission, only: [:create], controller: 'direct_admissions'

  resources :hospitalizations, only: [:show] do
    collection do
      get :census
      get :historical
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
  resources :surgeries, only: [:index, :show] do
    collection do
      get :search
    end
  end

  resources :surgery_team_members, only: [:create, :destroy]

  resources :documents, only: [:index, :create, :destroy]

  namespace :quirofanos do
    get :schedule, to: 'dashboard#schedule'
    get :weekly, to: 'dashboard#weekly'
    resources :surgeries, only: [:index, :create, :update, :destroy], controller: 'surgeries' do
      member do
        put :close
        put :cancel
      end
    end
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
      put :block
      put :unblock
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
    member do
      put :restore
    end
  end
  resources :lab_parameter_groups, only: [:index, :create, :update, :destroy] do
    member do
      put :restore
    end
  end

  resources :permissions, only: [:index]

  resource :email_settings, only: [:show, :update] do
    post :test
  end

  resource :company_settings, only: [:show, :update]
  resource :storage_configurations, only: [:show, :update]
  resource :password_policies, only: [:show, :update]
  resource :session_settings, only: [:show, :update]
  resource :access_policies, only: [:show, :update]
  resource :general_settings, only: [:show, :update]
  resource :emergency_modes, only: [:show, :update] do
    post :block
    post :unblock
  end
  resource :backup_configurations, only: [:show, :update] do
    post :run_now
  end

  get 'audit_logs', to: 'audit_logs#index'

  resources :appointment_displays

  resources :appointments, only: [:index, :show, :create, :update] do
    member do
      post :complete
    end
    collection do
      get :available_slots
    end
    resource :record, only: [:show, :create, :update], controller: 'appointment_records'
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

  get 'emergencies/:emergency_id/medical_history', to: 'medical_history#for_emergency'
  get 'hospitalizations/:hospitalization_id/medical_history', to: 'medical_history#for_hospitalization'

  resources :notifications, only: [:index] do
    member do
      put :mark_read
    end
    collection do
      put :mark_all_read
    end
  end
end
