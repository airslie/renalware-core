Rails.application.routes.draw do
  resources :patients, :except => [] do
    member do
      get :demographics
      get :clinical_summary
    end
  end

  resources :patient_events, :only => [:new, :create, :index]

  # TODO - This will probably change in future
  root to: "patients#index"

  resources :patient_event_types, :except => [:show, :delete] 
end
