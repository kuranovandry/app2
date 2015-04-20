Rails.application.routes.draw do
  # resources :users
  resources :home
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %w(index create destroy)
    end
  end
  root 'home#index'

end
