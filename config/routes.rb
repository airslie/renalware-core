Rails.application.routes.draw do
  resources :patients, :except => [:destroy] do
    member do
      get :demographics
      get :clinical_summary
      get :medications
      get :medications_index
    end
    collection do
      get :search
    end
    resources :patient_events, :only => [:new, :create, :index]
  end

  # TODO - This will probably change in future
  root to: "patients#index"

  resources :patient_event_types, :except => [:show]

  resources :drugs, :except => [:show]
end
