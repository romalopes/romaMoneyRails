RomaMoneyRails::Application.routes.draw do
   #get "transactions/new"
  # get "transactions/create"
  # get "transactions/edit"
  # get "transactions/update"
  # get "transactions/destroy"
  
  # get "accounts/new"
  # get "accounts/destroy"
  #get "users/new"
  root :to => "home#index"


  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

 # root  'home#index'
  match '/',        to: 'home#index',    via: 'get'
  match '/home',    to: 'home#index',    via: 'get'
  match '/help',    to: 'home#help',    via: 'get'
#  match '/about',   to: 'static_pages#about',   via: 'get'
#  match '/contact', to: 'static_pages#contact', via: 'get'

  match '/createAccount',  to: 'accounts#new',            via: 'get'
  match '/createTransaction',  to: 'transactions#new',            via: 'get'

  match '/stats',  to: 'transactions#stats',            via: 'get'


  resources :accounts

  resources :transactions do
    member do
      get :stats
    end
  end
    
  resources :users do
    member do
      get :change_to_this, :change_account, :change_account_ajax   #define following_user_path, followers_user_path
    end
  end

    #member do
    #  get :xxx, :yyy   #define xxx_user_path, yyy_user_path
  #  end
  
 resources :sessions, only: [:new, :create, :destroy]


end
