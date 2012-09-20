SampleApp2::Application.routes.draw do
  get "charities/new"
  #eliminate this in 7.1.2

  resources :users do#eliminates need for => get "users/new", because this
                    #endows the app w/all the actions needed for
                    #RESTful Users resource
    member do
      get :following, :followers
    end
    # creates URIs /users/1/following and /users/1/followers
    # use get because both pages will be showing data, so we want them
    #to respond to GET requests
    # the member method means that the routes respond to URIs containing
    #the user id
    # note: we are not using "followed users" terminology here because
    #then the named route would be followed_users_user_path, so we just
    #use "following" instead, yielding following_user_path(1)
  end
  
  resources :sessions,      only: [:new, :create, :destroy]
    #defining roots for the Sessions resource, together with a custom
    #named route for the signin page, using the resources method to
    #define the standard RESTful routes. Using the :only option accepted
    #by resources allows restricting the actions to those listed
  resources :microposts,    only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  #the routes for user relationships (for use in the partials?)
  
  match '/create_charity', to: 'charities#new'
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete #via: :delete
  #indicates that the signout route should be invoked using an
  #HTTP DELETE request
  
  root to: 'static_pages#home'
  
  match '/signup',  to: 'users#new'
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about' 
  match '/contact', to: 'static_pages#contact'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
