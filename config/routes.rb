Rails.application.routes.draw do
  resources :patients, :only => [:new, :create, :show, :edit, :update]
end
