Rails.application.routes.draw do

  devise_for :users
  root "home#index"
  resources :matches, except: [:edit, :update, :destroy]

end
