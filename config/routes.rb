Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    get 'users/new' => 'devise/registrations#new', :as => 'new_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
    post 'users' => 'devise/registrations#create', :as => 'create_user_registration'
  end

  resources :products, path: :posts do
    member do
      post :add_comment
      delete :delete_comment
    end
  end

  root 'products#index'
end
