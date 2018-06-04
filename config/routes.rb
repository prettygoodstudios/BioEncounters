Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/admin/csv", to: "admin#upload_csv"
  post "/admin/upload", to: "admin#import_csv#admin"
  get "/admin/success", to: "admin#success"
end
