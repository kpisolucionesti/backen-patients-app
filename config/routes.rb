Rails.application.routes.draw do
  resources :patients
  resources :doctors
  resources :rooms
  resources :notes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "welcome#index"

end
