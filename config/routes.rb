Rails.application.routes.draw do
  root 'reports#index'

  devise_for :users
  resources :users
  resources :teams
  resources :categories

  get 'stats' => 'stats#index'
  get 'stats/user'     => 'stats#user'
  get 'stats/team'     => 'stats#team'
  get 'stats/category' => 'stats#category'
  get 'stats/all'      => 'stats#all'

  post 'stat_reports/user'     => 'stat_reports#user'
  post 'stat_reports/team'     => 'stat_reports#team'
  post 'stat_reports/category' => 'stat_reports#category'
  post 'stat_reports/all'      => 'stat_reports#all'

  post 'exports/stat' => 'exports#stat'

  resources :reports
  get  'reports/:id/sign'   => 'reports#sign',   :as => :sign_report
  get  'reports/:id/export' => 'reports#export', :as => :timesheet_export
  post 'reports/search'     => 'reports#search'

  match "*path", to: "application#not_found", via: :all
end
