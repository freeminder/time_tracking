Rails.application.routes.draw do
  root 'reports#index'

  devise_for :users
  resources :users
  resources :teams
  resources :categories

  resources :stats
  get 'stats/user' => 'stats#user'
  post 'stats/user' => 'stats#reports'
  get 'stats/team' => 'stats#team'
  post 'stats/team' => 'stats#reports'
  get 'stats/category' => 'stats#category'
  post 'stats/category' => 'stats#reports'
  get 'stats/all' => 'stats#all'
  post 'stats/all' => 'stats#reports'

  resources :reports
  get 'reports/:id/export' => 'reports#export'
  post 'reports/search' => 'reports#search'

  match "*path", to: "application#not_found", via: :all
end
