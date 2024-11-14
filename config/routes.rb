Rails.application.routes.draw do
  get "stocks/intraday"
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#index"
end
