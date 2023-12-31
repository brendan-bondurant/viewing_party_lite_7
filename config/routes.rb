Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  delete '/logout', to: 'sessions#destroy', as: :logout
  root "application#index"
  get '/register', to: 'users#new'
  post '/users/:id', to: 'viewing_party#create'
  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login_user'
  resources :users, only: [:show, :create] do
    resources :movies, only: [:index, :show], on: :member do
      resources :viewing_party, only: [:new]
    end
    get 'discover', on: :member
  end
  resources :movies, only: [:index, :show] do
    resources :viewing_parties, only: [:new]
  end

end
