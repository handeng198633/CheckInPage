Rails.application.routes.draw do
  get 'window_requests/index'
  post '/apply' => 'window_requests#apply'
  post '/open' => 'window_requests#open'
  post '/hold' => 'window_requests#hold'
  post '/select' => 'window_requests#select'
  resources :window_requests
  resources :messages
  devise_for :users
  root to: "window_requests#index"

  mount ActionCable.server, at: '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
