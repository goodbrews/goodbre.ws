Dir.glob(Rails.root.join('lib', 'routing_constraints', '*.rb')).each { |f| require f }

Goodbrews::Application.routes.draw do
  root to: 'dashboard#index', constraints: SignedInConstraint.new(true)
  root to: 'pages#welcome',   constraints: SignedInConstraint.new(false)

  constraints AdminConstraint.new do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  resource :account, controller: :account, except: :show do
    collection do
      get  :sign_in,  controller: :authentication, action: :sign_in,      as: :sign_in
      post :sign_in,  controller: :authentication, action: :authenticate, as: :authenticate
      post :sign_out, controller: :authentication, action: :sign_out,     as: :sign_out
    end

    resources :password_reset, only: [:new, :create, :update] do
      member do
        get '', action: :edit, as: :edit
      end
    end
  end

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
