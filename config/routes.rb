Rails.application.routes.draw do
  get "stocks/search", to: "stocks#intraday"
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :users do
      member do
        patch :approve
      end
    end
    get "transactions", to: "dashboard#transactions"
    root "dashboard#index"
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
        get "sell/:symbol", to: "trading#sell", as: :sell
        post "sell/:symbol", to: "trading#process_sell", as: :process_sell
      end
    end
    resources :transactions, only: [ :index ]
  end

  root "pages#index"
end
