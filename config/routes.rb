Rails.application.routes.draw do

    devise_for :users, class_name: 'Renalware::User',
      controllers: { registrations: "renalware/devise/registrations", sessions: "renalware/devise/sessions" }

  scope module: "renalware" do

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
        get :manage_medications
        get :problems
        get :capd_regime
        get :apd_regime
      end

      resource :clinical_summary, only: :show
      resource :death, only: [:edit, :update]
      resource :pd_summary, only: :show
      resource :esrf, only: [:edit, :update], controller: "esrf"
      resources :events, only: [:new, :create, :index]
      resources :modalities, only: [:new, :create, :index]
      resources :peritonitis_episodes, only: [:new, :create, :show, :edit, :update]
      resources :exit_site_infections, only: [:new, :create, :show, :edit, :update]
      resources :pd_regimes, only: [:new, :create, :edit, :update, :show]
      resources :clinic_visits
      resources :capd_regimes, :controller => "pd_regimes", :type => "CapdRegime"
      resources :apd_regimes, :controller => "pd_regimes", :type => "ApdRegime"
      resources :letters

      namespace :transplants do
        resource :recipient_workup, except: :destroy
        resource :donor_workup, except: :destroy
      end
    end

    resources :deaths, only: :index, as: :patient_deaths

    resources :clinic_visits do
      resources :letters, controller: 'clinic_letters', only: [:new, :edit]
    end

    get 'authors/:author_id/letters', to: 'letters#author', as: 'author_letters'

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
end
