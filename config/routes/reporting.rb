# frozen_string_literal: true

namespace :reporting do
  resources :audits, except: [:destroy, :create, :new]
  resources :audit_refreshments, only: [:create]
  resources :reports, only: [:index, :show]
end
