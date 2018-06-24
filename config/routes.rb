Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :location
  resources :encounter
  resources :specie
  get "/admin", to: "admin#index"
  get "/admin/csv", to: "admin#upload_csv"
  post "/admin/upload", to: "admin#import_csv#admin"
  get "/admin/success", to: "admin#success"
  get "/playground", to: "location#playground"
  root to: "location#index"
end
