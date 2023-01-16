Rails.application.routes.draw do
  get 'home/index'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "home#index"
  #devise_for :users
  
  devise_for :users, controllers: { sessions: 'users/sessions', 
    registrations: 'users/registrations',
  }

  namespace :users do
    resources :admins
    resources :employees 
    
  end

  resources :leaves
  resources :attendances
  resources :salaries
  resources :tax_deductions
 
  #get '/my_leaves/:current_user.id', to: 'leaves#my_leaves'
end
