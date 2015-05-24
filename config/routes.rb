Rails.application.routes.draw do
  root 'application#index'
  get 'application/index'

  resources :stats
  get 'stats/user' => 'stats#user'
  post 'stats/user' => 'stats#reports'
  get 'stats/team_category' => 'stats#team_category'
  post 'stats/team_category' => 'stats#reports'
  get 'stats/team' => 'stats#team'
  post 'stats/team' => 'stats#reports'
  get 'stats/category' => 'stats#category'
  post 'stats/category' => 'stats#reports'
  get 'stats/all' => 'stats#all'
  post 'stats/all' => 'stats#reports'


  resources :reports
  post 'reports/create' => 'reports#create'
  get 'reports/:id/export' => 'reports#export'
  post 'reports/search' => 'reports#search'
  get 'reports/:id/sign' => 'reports#sign'

  resources :categories
  get 'categories/:id/destroy' => 'categories#destroy'

  resources :teams
  get 'teams/:id/destroy' => 'teams#destroy'

  devise_for :users
  resources :users
  get 'users/:id/destroy' => 'users#destroy'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

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
