RomaMoneyRails::Application.routes.draw do
  get "users/new"
  root :to => "home#index"


  match '/signup',  to: 'users#new',            via: 'get'

 # root  'home#index'
  match '/',        to: 'home#index',    via: 'get'
  match '/home',    to: 'home#index',    via: 'get'
  match '/help',    to: 'home#help',    via: 'get'
#  match '/about',   to: 'static_pages#about',   via: 'get'
#  match '/contact', to: 'static_pages#contact', via: 'get'

  resources :users do
    #member do
    #  get :xxx, :yyy   #define xxx_user_path, yyy_user_path
  #  end
  end
 #resources :sessions, only: [:new, :create, :destroy]


end
