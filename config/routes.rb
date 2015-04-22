Rails.application.routes.draw do
  # resources :users
  resource :home
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users
    end
  end
  root 'home#index'

end
