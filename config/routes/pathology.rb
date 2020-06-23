# frozen_string_literal: true

resources :patients, only: [] do
  namespace :pathology do
    resources :charts, only: [:show]
    get "observations/current",
        to: "current_observation_results#index",
        as: "current_observations"
    get "observations/recent",
        to: "recent_observation_results#index",
        as: "recent_observations"
    get "observations/historical",
        to: "historical_observation_results#index",
        as: "historical_observations"
    scope constraints: { format: :json, date: /\d{4}-\d{2}-\d{2}/ } do
      get "observations/nearest/code_group/:code_group_id/date/:date",
          to: "nearest_observation_results#index",
          as: "nearest_observations"
    end
    resources :observation_requests, only: [:index, :show]
    resources :patient_rules
    get "descriptions/:description_id/observations",
        to: "observations#index",
        as: "observations"
    resources :required_observations, only: :index
  end
end

namespace :pathology do
  resources :code_groups
  resources :observation_descriptions, except: :destroy
  namespace :requests do
    # NOTE: This needs to be POST since the params may exceed url char limit in GET
    post "requests/new", to: "requests#new", as: "new_request"
    resources :requests, only: [:create, :index, :show]
    resources :rules, only: :index
  end
end
