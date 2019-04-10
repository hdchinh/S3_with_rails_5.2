Rails.application.routes.draw do
  get 'home/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "upload_files/create_file", to: "upload_files#create_file"

  post "upload_files/create_file", to: "upload_files#upload_file", as: "upload_files"
  
  root "upload_files#create_file"
end
