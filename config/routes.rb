Rails.application.routes.draw do

  devise_for :users, class_name: "Renalware::User", controllers: {
    registrations: "renalware/devise/registrations",
    sessions: "renalware/devise/sessions"
  }

  # enable mail previews in all environments
  get "/rails/mailers" => "rails/mailers#index"
  get "/rails/mailers/*path" => "rails/mailers#preview"

  scope module: "renalware" do
    root to: "dashboard/dashboards#show"

    namespace :admin do
      resources :users
    end

    resources :bookmarks, controller: "patients/bookmarks", only: :destroy
    resource :dashboard, only: :show, controller: "dashboard/dashboards"

    # Clinics
    resources :appointments, controller: "clinics/appointments", only: [:index]
    resources :clinic_visits, controller: "clinics/clinic_visits"

    namespace :doctors do
      resources :doctors
    end

    resources :deaths, only: :index, as: :patient_deaths

    namespace :drugs do
      resources :drugs, except: :show do
        collection do
          scope format: true, constraints: { format: :json } do
            get :selected_drugs
          end
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
      resource :list, only: :show
    end
    get "authors/:author_id/letters", to: "letters/letters#author", as: "author_letters"

    namespace :pathology do
      namespace :requests do
        # NOTE: This needs to be POST since the params may exceed url char limit in GET
        post "requests/new", to: "requests#new", as: "new_request"
        resources :requests, only: [:create, :index, :show]
        resources :rules, only: :index
      end
    end

    namespace :pd do
      resources :bag_types, except: [:show]
      resources :infection_organisms
    end

    namespace :renal do
      resources :prd_descriptions, only: [:search] do
        collection do
          get :search
        end
      end
    end

    namespace :system do
      resources :email_templates, only: :index
    end

    namespace :transplants do
      resource :wait_list, only: :show
    end

    # Patient-scoped Routes
    #
    # Please add all non patient-scoped routes above
    #
    resources :patients, except: [:destroy] do
      collection do
        get :search
      end

      resource :clinical_summary, only: :show
      resource :death, only: [:edit, :update]

      resources :bookmarks, only: :create, controller: "patients/bookmarks"

      namespace :accesses do
        resource :dashboard, only: :show
        resources :assessments, except: [:index, :destroy]
        resources :procedures, except: [:index, :destroy]
        resources :profiles, except: [:index, :destroy]
      end

      # Clinics
      resources :clinic_visits, controller: "clinics/clinic_visits"

      # Events
      resources :events, only: [:new, :create, :index], controller: "events/events"

      namespace :hd do
        resource :dashboard, only: :show
        resource :preference_set, only: [:edit, :update]
        resource :profile, only: [:show, :edit, :update]
        resources :sessions, except: [:destroy]
        resources :dry_weights, except: [:show, :destroy]
      end

      # Medications
      resources :prescriptions, controller: "medications/prescriptions", except: [:destroy]
      namespace :medications do
        # TODO move above resource into namespace
        resources :prescriptions, only: [] do
          resource :termination, only: [:new, :create]
        end
      end

      namespace :letters do
        resources :letters do
          resource :pending_review, controller: "pending_review_letters", only: :create
          resource :rejected, controller: "rejected_letters", only: :create
          resource :approved, controller: "approved_letters", only: :create
          resource :completed, controller: "completed_letters", only: :create
          resource :formatted, controller: "formatted_letters", only: :show
        end
      end

      namespace :renal do
        resource :profile, only: [:edit, :update]
      end

      # Modalities
      resources :modalities, only: [:new, :create, :index], controller: "modalities/modalities"

      namespace :pd do
        resource :dashboard, only: :show
        resources :apd_regimes, controller: "regimes", type: "ApdRegime"
        resources :capd_regimes, controller: "regimes", type: "CapdRegime"
        resources :regimes, only: [:new, :create, :edit, :update, :show]
        resources :peritonitis_episodes, only: [:new, :create, :show, :edit, :update]
        resources :exit_site_infections, only: [:new, :create, :show, :edit, :update]
      end
      member do
        get :capd_regime
        get :apd_regime
      end

      namespace :pathology do
        get "observations/current", to: "current_observation_results#index", as: "current_observations"
        get "observations/recent", to: "recent_observation_results#index", as: "recent_observations"
        get "observations/historical", to: "historical_observation_results#index", as: "historical_observations"
        resources :observation_requests, only: [:index, :show]
        resources :patient_rules
        get "descriptions/:description_id/observations", to: "observations#index", as: "observations"
        resources :required_observations, only: :index
      end

      # Problems
      resources :problems, controller: "problems/problems" do
        post :sort, on: :collection
        resources :notes, only: [:index, :new, :create], controller: "problems/notes"
      end

      namespace :transplants do
        resource :donor_dashboard, only: :show
        resource :donor_workup, only: [:show, :edit, :update]
        resources :donor_operations, expect: [:index, :destroy] do
          resource :followup, controller: "donor_followups"
        end

        resources :donations, expect: [:index, :destroy]
        resource :recipient_dashboard, only: :show
        resource :recipient_workup, only: [:show, :edit, :update]
        resources :recipient_operations, expect: [:index, :destroy] do
          resource :followup, controller: "recipient_followups"
        end

        resource :registration, expect: [:index, :destroy] do
          resources :statuses, controller: "registration_statuses"
        end
      end
    end
  end
end
