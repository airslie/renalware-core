Rails.application.routes.draw do
  resources :patients, :only => [:show]
end
