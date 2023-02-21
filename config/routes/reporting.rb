# frozen_string_literal: true

namespace :reporting do
  resources :audits, except: [:destroy, :create, :new]
  resources :view_metadata_refreshments, only: [:create]
  resources :reports, only: [:index, :show]
end
