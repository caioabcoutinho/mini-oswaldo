Rails.application.routes.draw do
  resources :appointments
  namespace :admin do
    resources :users
  end
  devise_for :users, skip: [:registrations]

  root to: "dashboard#index"

  resources :hubs do
    resources :stock_items, only: [:create]
  end

  resources :categories
  resources :products

  resources :appointments do
    member do
      patch :complete
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
  
end
