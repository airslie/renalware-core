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


    get "authors/:author_id/letters", to: "letters#author", as: "author_letters"

    resources :bag_types, except: [:show]

    resources :clinic_visits do
      resources :letters, controller: "clinic_letters", only: [:new, :edit]
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

    resources :infection_organisms
    resources :medications, controller: :polymorphic_medications

    namespace :modalities do
      resources :descriptions, except: [:show]
      resources :reasons, only: [:index]
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
      resources :clinic_visits
      resources :events, only: [:new, :create, :index], controller: "events/events"
      resources :exit_site_infections, only: [:new, :create, :show, :edit, :update]
      resources :letters

      resources :medications, only: :index
      patch "medications", to: "medications#update", as: "medications_batch"

      resources :modalities, only: [:new, :create, :index], controller: "modalities/modalities"
      resources :pd_regimes, only: [:new, :create, :edit, :update, :show]
      resources :peritonitis_episodes, only: [:new, :create, :show, :edit, :update]

      resources :problems, controller: "problems/problems"
      patch "problems", to: "problems/problems#update", as: "problems_batch"

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

    resources :snomed, only: [:index]
  end
end
