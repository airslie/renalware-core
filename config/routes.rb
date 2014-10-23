Rails.application.routes.draw do
  resources :patients, :except => [:destroy]
end
