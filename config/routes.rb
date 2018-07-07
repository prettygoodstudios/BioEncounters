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
  get "/geoapi", to: "location#geo_json_api"
  get "/get_by_state", to: "location#get_by_state"
  get "/my_encounters", to: "encounter#my_encounters"
  get "/user_encounters", to: "encounter#user_encounters"
  root to: "location#index"
end
