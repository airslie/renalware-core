# frozen_string_literal: true

resources :patients, only: [] do
  namespace :hd do
    resource :mdm, only: :show, controller: "mdm"
    resource :dashboard, only: :show
    resource :protocol,
             only: :show,
             constraints: { format: /(pdf)/ },
             defaults: { format: :pdf }
    resource :preference_set, only: [:edit, :update]
    resource :current_profile,
             only: [:show, :edit, :update],
             path: "/profiles/current",
             controller: "current_profile"
    resources :historical_profiles,
              only: [:index, :show],
              path: "/profiles/historical"
    resources :sessions
  end
end

namespace :hd do
  scope format: true, constraints: { format: :json } do
    get "patients_dialysing_at_unit" => "patients#dialysing_at_unit"
    get "patients_dialysing_at_hospital" => "patients#dialysing_at_hospital"
  end

  resources :transmission_logs, only: [:show, :index]
  resources :cannulation_types, except: :show
  resources :dialysers, except: :show
  resources :dialysates, except: :show
  resource :ongoing_sessions, only: :show
  resources :mdm_patients, only: :index
  resources :mdm_patients, only: :index
  constraints(named_filter: /(on_worryboard)/) do
    get "mdm_patients/:named_filter", to: "mdm_patients#index", as: :filtered_mdm_patients
  end
  resources :unmet_preferences, only: :index
  resources :units, only: [] do
    resources :stations do
      post :sort, on: :collection
    end
    resources :diaries, only: [:index, :show]
    get "diaries/:year/:week_number/edit", to: "diaries#edit", as: :edit_diary
  end
  resources :diaries, only: [] do
    resources :slots, except: :show, controller: :diary_slots
    get "slots/day/:day_of_week/period/:diurnal_period_code_id/station/:station_id",
        to: "diary_slots#show",
        as: :refresh_slot
  end
end
