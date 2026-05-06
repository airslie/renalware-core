resources :patients, only: [] do
  namespace :renal do
    resource :profile, only: %i(show edit update)
  end
end

namespace :renal do
  resources :aki_alerts, only: %i(edit update index)
  resources :safety_alerts, only: %i(index destroy) do
    get :historical, on: :collection
  end
  resources :registry_preflight_checks, only: [] do
    collection do
      get :patients
      get :deaths
      get :missing_esrf
    end
  end
end
