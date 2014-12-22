Rails.application.routes.draw do
  resources :patients, :except => [:destroy] do
    member do
      get :demographics
      get :clinical_summary
      get :medications
      get :medications_index
      get :problems
    end
    collection do
      get :search
      get :death
    end
    resources :patient_events, :only => [:new, :create, :index]
  end

  # TODO - This will probably change in future
  root to: "patients#index"

  resources :patient_event_types, :except => [:show]

  resources :drugs, :except => [:show] do
    collection do
      get :search
    end 
  end 

  resources :snomed, :only => [:index]

  resources :modality_codes, :except => [:show]

end
