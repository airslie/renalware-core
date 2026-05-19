# frozen_string_literal: true

Renalware::Heroic::Engine.routes.draw do
  namespace :bio_bank do
    resources :patients, only: [] do
      resources :samples
    end
    resources :samples, only: [] do
      resources :aliquots
    end
    resources :sample_uploads
    resources :usage_uploads
    resources :aliquots, only: [] do
      resource :usage, controller: "aliquot_usages"
    end
  end
  namespace :reports do
    scope format: true, constraints: { format: :csv } do
      resources :downloads, only: :show
    end
  end
end
