Rails.application.routes.draw do
  resources :patients do
    collection do
      get :find_by_ci
    end
  end
  resources :doctors
  resources :rooms
  resources :notes
  resources :emergencies

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post "sign_up",  to: "registrations#create"
        post "sign_in",  to: "sessions#create"
        delete "sign_out", to: "sessions#destroy"
      end
    end
  end
end
