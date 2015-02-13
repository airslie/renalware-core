Rails.application.routes.draw do
  resources :patients, :except => [:destroy] do
    member do
      get :demographics
      get :clinical_summary
      get :medications
      get :medications_index
      get :problems
      get :modality
      get :death_update
      get :esrf_info
      get :pd_info 
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

  resources :modality_reasons, :only => [:index]

end
