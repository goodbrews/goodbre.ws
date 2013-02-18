Dir.glob(Rails.root.join('lib', 'routing_constraints', '*.rb')).each { |f| require f }

Goodbrews::Application.routes.draw do
  root to: 'dashboard#index', constraints: SignedInConstraint.new(true)
  root to: 'pages#welcome',   constraints: SignedInConstraint.new(false)

  constraints AdminConstraint.new do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  concern :searchable do
    get :search, on: :collection
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

  resource :dashboard, controller: :dashboard, only: [] do
    collection do
      get :likes
      get :dislikes
      get :fridge
      get :hidden
      get :similar
    end
  end

  resources :users, only: :show, concerns: [:searchable] do
    member do
      get :likes
      get :dislikes
      get :fridge
      get :similar
    end
  end

  resources :beers, only: [:index, :show], concerns: [:searchable] do
    member do
      post   :like
      delete :like,     action: :unlike,     as: :unlike
      post   :dislike
      delete :dislike,  action: :undislike,  as: :undislike
      post   :hide
      delete :hide,     action: :unhide,     as: :unhide
      post   :bookmark
      delete :bookmark, action: :unbookmark, as: :unbookmark
    end

    get :search, on: :collection
  end

  resources :breweries, only: [:index, :show], concerns: [:searchable] do
    resources :beers, only: [:index, :show]
  end

  resources :styles, only: [:index, :show] do
    resources :beers, only: [:index, :show]
  end

  resources :events, only: [:index, :show]

  resources :guilds, only: [:index, :show]

  controller :pages do
    get :welcome
    get :about
    get :privacy
    get :terms
  end
end
