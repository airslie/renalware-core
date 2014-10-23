Rails.application.routes.draw do
  resources :patients, :except => [:destroy]

  # TODO - This will probably change in future
  root to: "patients#index"
end
