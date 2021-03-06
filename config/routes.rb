Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new' # =users/new
  get '/login', to: 'sessions#new'
  delete '/logout', to: 'sessions#destroy'
  post '/login', to: 'sessions#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  resources :users
  resources :account_activations,  only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :update, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :users do 
    member do
      get :following, :followers #GET /users/1/following and GET #/users/1/followers
    end
  end
end
