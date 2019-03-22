# frozen_string_literal: true

namespace :api do
  # The UKRDC XML API
  namespace :ukrdc, defaults: { format: :xml } do
    resources :patients,
              only: :show,
              constraints: { format: :xml }
  end
  # The JSON API
  namespace :v1, constraints: { format: :json }, defaults: { format: :json } do
    resources :patients, only: [:show, :index], controller: "patients/patients" do
      resources :prescriptions, controller: "medications/prescriptions", only: [:index]
      namespace :hd do
        resource :current_profile,
                 only: :show,
                 path: "/profiles/current",
                 controller: "current_profile"
      end
    end
  end
end
