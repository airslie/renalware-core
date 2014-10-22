Rails.application.routes.draw do
  resources :patients, :only => [:show, :edit, :update]
end
