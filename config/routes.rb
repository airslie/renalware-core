Rails.application.routes.draw do
  resources :patients, :except => [:show, :destroy] do
    member do
      get :demographics
    end
  end

  # TODO - This will probably change in future
  root to: "patients#index"
end
