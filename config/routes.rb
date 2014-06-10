Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  get '/frontends/:id/products_by_category', controller: :frontends, action: :products_by_category, as: :products_category
  get '/frontends/:id/product_detail', controller: :frontends, action: :product_detail, as: :product_detail
  post '/frontends/:id/add_to_cart', controller: :frontends, action: :add_to_cart
  get '/frontends/:id/show_cart', controller: :frontends, action: :show_cart
  put '/frontends/update_cart', controller: :frontends, action: :update_cart
  delete '/frontends/:id/remove_item', controller: :frontends, action: :remove_item
  get '/frontends/profile', controller: :frontends, action: :profile
  get '/frontends/checkout', controller: :frontends, action: :checkout
  get '/frontends/search', controller: :frontends, action: :search
  put '/frontends/update_billing_information', controller: :frontends, action: :update_billing_information
  get '/frontends/finish_shopping', controller: :frontends, action: :finish_shopping
  get '/frontends/order', controller: :frontends, action: :order

  root 'frontends#index'

  namespace :admin do
    resources :category
    resources :products
  end

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
