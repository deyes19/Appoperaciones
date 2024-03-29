Rails.application.routes.draw do
  resources :relocations
  resources :statuses
  resources :rankactives
  get '/search_active', to: 'users#search_active', as: 'search_active'
  devise_for :users
  scope '/admin' do
    resources :users
    
  end
  resources :roles
  resources :users
  resources :ubications do
    collection do
      post :import
    end
  end
  root "actives#index"
  patch 'actives/:id', to: 'actives#update'
  patch 'actives/:id/status', to: 'actives#down', as:'actives_down_status'
  delete 'actives/:id', to: 'actives#destroy'
  resources :actives do
    
    collection do
      get 'not_active'
      post :import1
      post :import2
    end
  end
  
  post 'actives/options', as: 'actives_options'
  post 'actives/optionss', as: 'actives_optionss'

  resources :active_types
  resources :suppliers
  resources :kinds
  resources :brands
  resources :invoices
  resources :groups
  resources :destinations do
    collection do
      post :import
    end
  end
  
  resources :centers do
    collection do
      post :import
    end
  end
  resources :zones do
  collection do
    post :import
  end
end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
