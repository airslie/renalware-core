# frozen_string_literal: true

resources :patients, only: [] do
  namespace :pd do
    resource :dashboard, only: :show
    resources :apd_regimes,
              controller: "regimes",
              type: "PD::APDRegime",
              only: [:new, :create, :edit, :update, :show, :index]
    resources :capd_regimes,
              controller: "regimes",
              type: "PD::CAPDRegime",
              only: [:new, :create, :edit, :update, :show, :index]
    resources :regimes, only: [:new, :create, :edit, :update, :show]
    resources :peritonitis_episodes, only: [:new, :create, :show, :edit, :update]
    resources :exit_site_infections, only: [:new, :create, :show, :edit, :update]
    resources :pet_adequacy_results, except: [:destroy]
    resources :unified_pet_adequacies, only: [:new, :create]
    resources :pet_results
    resources :adequacy_results
    resources :assessments, except: [:index, :destroy]
    resources :training_sessions, except: [:index, :destroy]
    resource :mdm, only: :show, controller: "mdm"
  end
end

namespace :pd do
  resources :pet_completions, only: :index
  resources :adequacy_completions, only: :index
  resources :bag_types, except: [:show]
  resources :infection_organisms
  resources :mdm_patients, only: :index
  constraints(named_filter: /(on_worryboard)/) do
    get "mdm_patients/:named_filter", to: "mdm_patients#index", as: :filtered_mdm_patients
  end
end
