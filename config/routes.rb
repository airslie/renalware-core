Rails.application.routes.draw do

  devise_for :users, class_name: "Renalware::User", controllers: {
    registrations: "renalware/devise/registrations",
    sessions: "renalware/devise/sessions"
  }

  scope module: "renalware" do
    root to: "patients#index"

    namespace :admin do
      resources :users
    end


    get "authors/:author_id/letters", to: "letters/letters#author", as: "author_letters"

    resources :bag_types, except: [:show]

    resources :clinic_visits, controller: "clinics/clinic_visits" do
      resources :letters, controller: "letters/clinic_letters", only: [:new, :edit]
    end

    resources :deaths, only: :index, as: :patient_deaths
    resources :doctors

    namespace :drugs do
      resources :drugs, except: :show do
        collection do
          get :selected_drugs
        end
      end
    end

    namespace :events do
      resources :types, except: :show
    end

    namespace :hd do
      resources :cannulation_types, except: :show
      resources :dialysers, except: :show
      resource :ongoing_sessions, only: :show
    end

    namespace :hospitals do
      resources :units, except: :show
    end

    resources :infection_organisms

    namespace :modalities do
      resources :descriptions, except: [:show]
      resources :reasons, only: [:index]
    end

    namespace :letters do
      resources :descriptions, only: :search do
        collection do
          get :search
        end
      end
    end

    resources :patients, except: [:destroy] do
      member do
        get :capd_regime
        get :apd_regime
      end

      collection do
        get :search
      end

      resource :clinical_summary, only: :show
      resource :death, only: [:edit, :update]
      resource :esrf, only: [:edit, :update], controller: "esrf"
      resource :pd_summary, only: :show

      resources :apd_regimes, controller: "pd_regimes", type: "ApdRegime"
      resources :capd_regimes, controller: "pd_regimes", type: "CapdRegime"
      resources :clinic_visits, controller: "clinics/clinic_visits"
      resources :events, only: [:new, :create, :index], controller: "events/events"
      resources :exit_site_infections, only: [:new, :create, :show, :edit, :update]

      namespace :hd do
        resource :dashboard, only: :show
        resource :preference_set, only: [:edit, :update]
        resource :profile, only: [:show, :edit, :update]
        resources :sessions, except: [:destroy]
        resources :dry_weights, except: [:show, :destroy]
      end

      namespace :accesses do
        resource :dashboard, only: :show
        resources :assessments, except: [:index, :destroy]
        resources :procedures, except: [:index, :destroy]
        resources :profiles, except: [:index, :destroy]
      end

      namespace :letters do
        resources :letters
      end

      resources :medications

      resources :modalities, only: [:new, :create, :index], controller: "modalities/modalities"
      resources :pd_regimes, only: [:new, :create, :edit, :update, :show]
      resources :peritonitis_episodes, only: [:new, :create, :show, :edit, :update]

      resources :problems, controller: "problems/problems" do
        post :sort, on: :collection
        resources :notes, only: [:index, :new, :create], controller: "problems/notes"
      end

      namespace :pathology do
        get "observations/current", to: "current_observation_results#index", as: "current_observations"
        get "observations/recent", to: "recent_observation_results#index", as: "recent_observations"
        get "observations/historical", to: "historical_observation_results#index", as: "historical_observations"
        resources :observation_requests, only: [:index, :show]
        get "descriptions/:description_id/observations", to: "observations#index", as: "observations"
        resources :required_observations, only: :index
      end

      namespace :transplants do
        resource :recipient_dashboard, only: :show
        resource :recipient_workup, only: [:show, :edit, :update]
        resources :recipient_operations, expect: [:index, :destroy] do
          resource :followup, controller: "recipient_followups"
        end

        resource :donor_dashboard, only: :show
        resource :donor_workup, only: [:show, :edit, :update]
        resources :donor_operations, expect: [:index, :destroy] do
          resource :followup, controller: "donor_followups"
        end

        resources :donations, expect: [:index, :destroy]

        resource :registration, expect: [:index, :destroy] do
          resources :statuses, controller: "registration_statuses"
        end
      end
    end

    resources :prd_descriptions, only: [:search] do
      collection do
        get :search
      end
    end

    namespace :transplants do
      resource :wait_list, only: :show
    end

    resources :snomed, only: [:index]

    namespace :system do
      resources :email_templates, only: :index
    end
  end

  # enable mail previews in all environments
  get "/rails/mailers" => "rails/mailers#index"
  get "/rails/mailers/*path" => "rails/mailers#preview"
end
