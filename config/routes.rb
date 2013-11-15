RomaMoneyRails::Application.routes.draw do
  root :to => "home#index"

 # root  'home#index'
  match '/',        to: 'home#index',    via: 'get'
  match '/home',    to: 'home#index',    via: 'get'
  match '/help',    to: 'home#help',    via: 'get'
#  match '/about',   to: 'static_pages#about',   via: 'get'
#  match '/contact', to: 'static_pages#contact', via: 'get'

end
