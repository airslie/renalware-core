# frozen_string_literal: true

resources :patients, only: [] do
  namespace :clinical do
    resources :allergies, only: [:create, :destroy]
    resource :allergy_status, only: [:update]
    resource :profile, only: [:show, :edit, :update]
    resources :dry_weights, only: [:new, :create, :index]
    resources :body_compositions, except: :destroy
  end
end
