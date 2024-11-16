Rails.application.routes.draw do
  get "stocks/intraday"
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#index"

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :users do
      member do
        patch :approve  # Custom route for approving users
      end
    end
    root "dashboard#index"  # Makes admin/dashboard#index the root for /admin
  end
end
