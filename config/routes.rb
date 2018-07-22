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
  get "/get_by_date", to: "encounter#get_by_date"
    get "/get_by_range", to: "encounter#get_by_range"
  get "/get_by_date_api", to: "encounter#get_by_date_api"
  get "/get_by_range_api", to: "encounter#get_by_range_api"
  get "/my_encounters", to: "encounter#my_encounters"
  get "/user_encounters", to: "encounter#user_encounters"
  #V1 Api Routes
  namespace :api do
    namespace :v1 do
      resources :locations
      resources :species
      resources :encounters
      resources :sessions, only: [:create, :destroy]
    end
  end
  #Route Route
  root to: "location#index"
end
