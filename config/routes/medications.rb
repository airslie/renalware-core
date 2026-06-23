resources :patients, only: [] do
  resources :prescriptions, controller: "medications/prescriptions", except: :destroy

  namespace :medications do
    resources :outpatient_prescription_administrations, only: :index
    resources :prescription_batch_renewals, only: %i(new create)
    resources :reviews, only: :create, defaults: { format: :js }
    namespace :home_delivery do
      resources :events, only: %i(new create edit update show)
    end
    resources :prescriptions, only: [] do
      resource :termination, only: %i(new create)
    end
  end
end

namespace :medications do
  resources :prescriptions, only: [] do
    resources :outpatient_administrations,
              only: %i(new create destroy),
              controller: "outpatient_prescription_administrations"
  end
  resources :outpatient_prescription_administrations, only: [] do
    resource :witness, only: %i(edit update), controller: "outpatient_witnesses"
  end
  # medications_esa_prescriptions => /medications/esa_prescriptions
  resources :esa_prescriptions,
            only: :index,
            drug_type_name: :esa,
            controller: "drug_types/prescriptions"
  namespace :home_delivery do
    constraints(named_filter: /#{Renalware::Medications::Delivery::DRUG_TYPE_FILTERS.join('|')}/) do
      get "prescriptions/:named_filter", to: "prescriptions#index", as: :prescriptions
    end
  end
end
