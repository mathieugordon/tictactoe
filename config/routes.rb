Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  resources :matches, except: [:edit, :update, :destroy]
  resources :users
  post '/matches/:id/move/:cell', to: 'matches#move', as: 'move'

end
