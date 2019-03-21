# frozen_string_literal: true

resources :patients, only: [] do
  resources :clinic_visits, controller: "clinics/clinic_visits"
end

resources :appointments, controller: "clinics/appointments", only: [:new, :create, :index]
resources :clinic_visits, only: :index, controller: "clinics/visits"
