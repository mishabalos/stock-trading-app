Rails.application.routes.draw do
  get "stocks/search", to: "stocks#intraday"
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :users do
      member do
        patch :approve  # Custom route for approving users
      end
    end
    root "dashboard#index"  # Makes admin/dashboard#index the root for /admin
  end

  namespace :dashboard do
    get "/", to: "pages#index", as: :root
    resources :wallets, only: [ :new ] do
      collection do
        post :top_up
      end
    end
    get "portfolio", to: "trading#index"
    resources :trading, only: [ :index, :new ] do
      collection do
        post "buy/:symbol", to: "trading#buy", as: :buy
        post "sell/:symbol", to: "trading#sell", as: :sell
      end
    end
  end

  root "pages#index"
end
