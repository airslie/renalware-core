Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :users do
      collection do
        get :unapproved
        get :inactive
      end
    end
  end

  resources :patients, except: [:destroy] do
    member do
      get :demographics
      get :clinical_summary
      get :manage_medications
      get :problems
      get :death_update
      get :esrf_info
      get :pd_info
    end
    collection do
      get :death
    end
    resources :events, only: [:new, :create, :index]
    resources :modalities, only: [:new, :create, :index]
    resources :peritonitis_episodes, only: [:new, :create, :show, :edit, :update]
    resources :exit_site_infections, only: [:new, :create, :show, :edit, :update]
    resources :pd_regimes, only: [:new, :create, :edit, :update, :show]

    resources :clinic_visits
    resources :letters
    resources :simple_letters, controller: 'letters', type: 'SimpleLetter', only: [:new, :edit]
    resources :death_notifications, controller: 'letters', type: 'DeathNotification', only: [:new, :edit]
    resources :discharge_summaries, controller: 'letters', type: 'DischargeSummary', only: [:new, :edit]
    resources :correction_letters, controller: 'letters', type: 'CorrectionLetter', only: [:new, :edit]
  end

  resources :clinic_visits do
    resources :letters, controller: 'clinic_letters', only: [:new, :edit]
  end

  get 'authors/:author_id/letters', to: 'letters#author'

  # TODO - This will probably change in future
  root to: "patients#index"

  resources :event_types, except: [:show]

  resources :drugs, except: [:show] do
    collection do
      get :selected_drugs
    end
    resources :drug_drug_types, only: [:index, :create, :destroy]
  end

  resources :snomed, only: [:index]

  resources :modality_codes, except: [:show]

  resources :modality_reasons, only: [:index]

  resources :bag_types, except: [:show]

  resources :doctors

end
