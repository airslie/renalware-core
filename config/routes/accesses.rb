# frozen_string_literal: true

resources :patients, only: [] do
  namespace :accesses do
    resource :dashboard, only: :show
    resources :assessments, except: [:index, :destroy]
    resources :procedures, except: [:index, :destroy]
    resources :profiles, except: [:index, :destroy]
    resources :plans, except: [:index, :destroy]
    resources :needling_assessments, except: [:index, :update, :show]
  end

  # Convenience redirects reporting
  get "accesses", to: redirect("/patients/%{patient_id}/accesses/dashboard")
  get "access", to: redirect("/patients/%{patient_id}/accesses/dashboard")
end
