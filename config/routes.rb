Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end

  mount Sidekiq::Web => '/sidekiq'

  root 'home#index'
  
  resources :sessions, only: [:new, :create, :destroy]
  get 'sign_in' => 'sessions#new'
  
  get 'sign_up' => 'registrations#new'

  post 'sign_up' => 'registrations#create'
  get 'confirm' => 'registrations#confirm'
  get 'welcome' => 'registrations#welcome'


  resources :group_messages

  resources :channel_accesses do
    collection do
      post 'national_gateway'
    end
  end

  resources :channels do
    member do
      put 'state'
    end
  end

  resources :passwords, only: [:new, :update] do
    collection do
      put 'request_change'
      put 'reset'
      get 'change'
    end
  end

  delete 'sign_out' => 'sessions#destroy'

  resources :permissions
  resources :project_permissions
  resources :channel_permissions

  resources :projects do
    member do
      get 'share'
      get 'sms_setting'
      post 'update_sms_setting'
    end

    collection do
      get 'list'
    end

    resources :alerts do

      collection do
        get 'matched'
        get 'share'
      end

      member do
        get 'new_groups'
        get 'new_keywords'
      end
      
    end
  end

  resources :alerts, only: [] do
    collection do
      get 'matched'
    end

    member do
      get 'new_groups'
      get 'new_keywords'
    end

    resources :alert_groups
    resources :alert_keywords

    resources :feed_entries do
      collection do
        get 'matched'
      end
    end
  end

  resources :groups do
    member do
      get 'new_members'
      get 'alerts'
    end
  end

  resources :memberships
  
  resources :members do
    member do
      get 'new_groups'
      get 'alerts'
    end
  end

  resources :users, only: [] do
    collection do
      get 'profile'
      put 'update_profile'

      get 'password'
      put 'update_password'
      get 'list'
    end

    member do
      put 'reset'
    end
  end

  # resources :alerts do
  #   collection do
  #     get 'matched'
  #   end

  #   member do
  #     get 'new_groups'
  #     get 'new_keywords'
  #   end

  #   resources :alert_groups
  #   resources :alert_keywords

  #   resources :feed_entries do
  #     collection do
  #       get 'matched'
  #     end
  #   end
  # end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
