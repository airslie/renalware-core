Rails.application.routes.draw do
  resources :patients, :except => [:destroy] do
    member do
      get :demographics
      get :clinical_summary
      get :manage_medications
      get :medications_index
      get :problems
      get :death_update
      get :esrf_info
      get :pd_info
    end
    collection do
      get :death
    end
    resources :patient_events, :only => [:new, :create, :index]
    resources :modalities, :only => [:new, :create, :index]
    resources :peritonitis_episodes, :only => [:new, :create, :show, :edit, :update]
    resources :exit_site_infections, :only => [:new, :create, :edit, :update]
  end

  # TODO - This will probably change in future
  root to: "patients#index"

  resources :patient_event_types, :except => [:show]

  resources :drugs, :except => [:show] do
    collection do
      get :selected_drugs
    end
    resources :drug_drug_types, :only => [:index, :create, :destroy]
  end

  resources :snomed, :only => [:index]

  resources :modality_codes, :except => [:show]

  resources :modality_reasons, :only => [:index]

end
