Rails.application.routes.draw do
  mount GrapeApi => '/api'
  mount GrapeSwaggerRails::Engine => '/swagger'
  mount Sidekiq::Web => '/sidekiq'

  root "orders#calc"
  get "up" => "rails/health#show", as: :rails_health_check
  get 'hello/index'
  get "welcome/index"

  namespace :admin do
    root "welcome#index"
  end

  resources :groups, only: [:index, :show, :create, :destroy]

  resources :vms, only: [:index]

  resources :users
  resource :login, only: [:show, :create, :destroy]
  
  resources :orders, defaults: { format: 'json' } do
    member do
      get 'approve'
    end

    collection do
      get 'check'
      get 'first'
      get 'calc'
    end
  end
end