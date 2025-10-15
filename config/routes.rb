Rails.application.routes.draw do
  devise_for :users
  
  resources :categories
  resources :tasks do
    member do
      patch :toggle
    end
    resources :subtasks, only: [:create, :destroy] do
      member do
        patch :toggle
      end
    end
  end
  
  post "theme/toggle", to: "theme#toggle", as: :toggle_theme
  get "dashboard", to: "dashboard#show", as: :dashboard
  root "tasks#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
