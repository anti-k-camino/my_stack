=begin
require 'sidekiq/web'
=end
Rails.application.routes.draw do
=begin
  authenticate :user, lambda{|u| u.admin?} do
    mount Sidekiq::Web => '/sidekiq'
  end
=end  
  apipie
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :users, only:[:index, :show]
  resources :attachments, only:[:destroy]
  resources :votes, only:[:destroy]
  resources :authorizations, only:[:new, :create]

  concern :votable do
    get :upvote, on: :member
    get :downvote, on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index]do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end    
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end  
  resources :comments, only:[:destroy]

  resources :questions, concerns: [:votable, :commentable] do      
    resources :answers, only:[:create, :destroy, :update], shallow: true, concerns: [:votable, :commentable] do      
      patch :best, on: :member      
    end
    post   '/subscribe'   => 'subscriptions#create'
    delete '/unsubscribe' => 'subscriptions#destroy'
  end  
  root 'questions#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#sindex'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
