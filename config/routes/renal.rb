# frozen_string_literal: true

resources :patients, only: [] do
  namespace :renal do
    resource :profile, only: [:show, :edit, :update]
  end
end

namespace :renal do
  resources :aki_alerts, only: [:edit, :update, :index]
  resources :registry_preflight_checks, only: [] do
    collection do
      get :patients
      get :deaths
    end
  end
end
