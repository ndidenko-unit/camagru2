Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
  # get 'users/:id', to: 'users#show', as: 'user'
  # get 'users', to: 'users#index', as: 'users'
  resources :products

  root 'products#index'
end
