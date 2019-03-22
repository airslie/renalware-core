# frozen_string_literal: true

resources :patients, only: [] do
  resources :prescriptions, controller: "medications/prescriptions", except: [:destroy]
  namespace :medications do
    namespace :home_delivery do
      resources :prescriptions,
                only: [:index],
                constraints: { format: /(pdf)/ },
                defaults: { format: :pdf }
    end
    resources :prescriptions, only: [] do
      resource :termination, only: [:new, :create]
    end
  end
end

namespace :medications do
  # medications_esa_prescriptions => /medications/esa_prescriptions
  resources :esa_prescriptions,
            only: :index,
            drug_type_name: :esa,
            controller: "drug_types/prescriptions"
end
