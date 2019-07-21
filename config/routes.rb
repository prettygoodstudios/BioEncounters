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
  get "/specie_geo_api", to: "encounter#specie_geo_api"
  get "/my_encounters", to: "encounter#my_encounters"
  get "/user_encounters", to: "encounter#user_encounters"
  get "/get_specie_encounter_graph_api/:specie", to: "encounter#get_encounters_time_graph_api"
  get "/encounter/csv_upload", to: "encounter#csv_upload",
  post "/encounter/csv_import_api", to: "encounter#import_csv"
  get "/encounter/csv_upload_success", to: "encounter#csv_upload_success"
  #V1 Api Routes
  namespace :api do
    namespace :v1 do
      resources :locations
      resources :species
      resources :encounters, only: [:create, :destroy, :update, :show, :index, :destroy]
      resources :sessions, only: [:create, :destroy]
      post "/sessions/authenticate", to: "sessions#authenticate"
      post "/sessions/create_user", to: "sessions#create_user"
      get "/encounters/get_by_date/range", to: "encounters#get_by_date"
      get "/encounters/get_by_month/range", to: "encounters#get_by_month"
      get "/encounters/get_by_specie_and_month/range", to: "encounters#get_by_specie_and_month"
      get "/encounters/user/:user", to: "encounters#get_user_encounters"
      get "/locations/states/all", to: "locations#get_states"
    end
  end
  #Route Route
  root to: "location#index"
end
